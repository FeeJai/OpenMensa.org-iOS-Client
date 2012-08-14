//
//  SecondViewController.m
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import "AddFavouriteMapViewController.h"


@implementation AddressAnnotation

@synthesize coordinate, cafeteriaID;


-(NSString *)subtitle {
    return address;
}


-(NSString *)title {
    return name;
}


-(id)initWithCoordinate:(CLLocationCoordinate2D)c name:(NSString *)fName address:(NSString *)fAddress andID:(NSNumber*) fid{
    
    if (c.longitude == 0 && c.latitude == 0)
        return nil;
    
    coordinate = c;
    name = fName;
    address = fAddress;
    cafeteriaID = fid;

    return self;
}

@end

#pragma mark -


@implementation AddFavouriteMapViewController


-(CLLocationCoordinate2D)findCoordinatesForAddress:(NSString*) address {
    
    CLLocationCoordinate2D coordinates;
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&key=AIzaSyCLK3BD-Dt5VvAtGZf0lMqsGATQUiAdShE&output=csv",
                           [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
    
    double latitude = 0;
    double longitude = 0;
    
    if ([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
        //Error handling
    }
    
    coordinates.latitude = latitude;
    coordinates.longitude = longitude;
    
    return coordinates;
}


-(void)addPinForCafeteria: (NSDictionary*) cafeteria {
       
    AddressAnnotation *pin = [[AddressAnnotation alloc]
                              initWithCoordinate: [self findCoordinatesForAddress:[cafeteria objectForKey:@"address"]]
                              name:[cafeteria objectForKey:@"name"]
                              address:[cafeteria objectForKey:@"address"]
                              andID: [cafeteria objectForKey:@"id"]];
    if (pin) {
        //[mapView addAnnotation:pin];
        [mapView performSelectorOnMainThread:@selector(addAnnotation:) withObject:pin waitUntilDone:false];
    } else {
        NSLog(@"Could not add cafeteria \"%@\" - retry in one second", [cafeteria objectForKey:@"name"]);
        [NSThread sleepForTimeInterval:1.1];
        [self performSelector:@selector(addPinForCafeteria:) withObject:cafeteria];
    }
}


-(void)updateMap {
    
    NSDate *lastAPIpdate = [api lastUpdate];
    UIApplication* app = [UIApplication sharedApplication];

    if (lastAPIpdate && ([lastAPIpdate timeIntervalSinceNow] > -60)) {
        
        //Data was received within the last 60 seconds
        NSLog(@"Updating Map");
        
        //We got the data, let's get the pins onto the map

        
        //NSThread *pinsThread = [[NSThread alloc] init];
        NSThread *pinsThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadMain:) object:nil];

        for (NSDictionary *cafeteria in [api cafeterias]) {
            
            //[self performSelectorInBackground:@selector(addPinForCafeteria:) withObject:cafeteria]; //multithreaded - no more freezing
            //+[NSThread sleepForTimeInterval:]
            [self performSelector:@selector(addPinForCafeteria:) onThread:pinsThread withObject:cafeteria waitUntilDone:false];
        }
        
        [pinsThread start]; // go!

        app.networkActivityIndicatorVisible = NO;
        //[self performSelector:@selector(updateMap) withObject:nil afterDelay:180];   //Refresh every three minutes
        
        
    } else {
        NSLog(@"No new data on API - retry");

        //Make API refresh data and try again in 5 seconds
        app.networkActivityIndicatorVisible = YES; 
        [api getData];
        [self performSelector:@selector(updateMap) withObject:nil afterDelay:5];
        
    }

}


#pragma mark - MapViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Mensa hinzufügen", @"Add Mensa");
        self.tabBarItem.image = [UIImage imageNamed:@"10-medical"];
    }
    
    api = [DataAPI instance];
    favourites = [FavouriteCafeteriaStorage instance];
    mapView = [[MKMapView alloc] init];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    
    self.view = mapView;
    
    //start loading data and auto updating
    [self updateMap];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


#pragma mark - MKMapViewDelegate protocol


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSNumber *cafeteriaID = [(AddressAnnotation*) [view annotation] cafeteriaID];
    NSLog(@"%@",cafeteriaID);
}


-(MKAnnotationView *) mapView:(MKMapView *)fMapView viewForAnnotation:(id <MKAnnotation>) annotation{
    if (annotation == mapView.userLocation) {
        return nil; // default to blue dot
    }
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pinView.pinColor = MKPinAnnotationColorRed;
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    pinView.rightCalloutAccessoryView = rightButton;
    
    return pinView;
}


- (void)mapView:(MKMapView *)theMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //[theMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    static NSDate *lastMapUpdate;
    
    if(!lastMapUpdate)
        lastMapUpdate = [NSDate date];
    
    //Nur innerhalb der ersten 15 Sekunden nach den ersten Positionsupdate Karte erneut ausrichten
    
    if ([lastMapUpdate timeIntervalSinceNow] > -15) {

    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.3;
    span.longitudeDelta = 0.3;
    
    
    CLLocationCoordinate2D location = [[userLocation location] coordinate];

    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:YES];
     
    }

}


-(void)mapView:(MKMapView *)fMapView regionDidChangeAnimated:(BOOL)animated {
    //[self updateMap];
}


#pragma mark - threading stuff

- (void)threadMain:(id)data {
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    while (1) { // 'isAlive' is a variable that is used to control the thread existence...
        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
}



@end
