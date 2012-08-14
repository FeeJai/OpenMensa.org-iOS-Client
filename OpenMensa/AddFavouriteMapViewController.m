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
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
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
        // Show error
    }
    
    coordinates.latitude = latitude;
    coordinates.longitude = longitude;
    
    return coordinates;
}



-(void)updateMap {
    
    NSDate *lastAPIpdate = [api lastUpdate];
    UIApplication* app = [UIApplication sharedApplication];

    if (lastAPIpdate && ([lastAPIpdate timeIntervalSinceNow] > -60)) {
        
        //Data was received within the last 60 seconds
        NSLog(@"Updating Map");
        
        //We got the data, let's get the pins onto the map

        for (NSDictionary *cafeteria in [api cafeterias]) {
           AddressAnnotation *pin = [[AddressAnnotation alloc]
                                      initWithCoordinate: [self findCoordinatesForAddress:[cafeteria objectForKey:@"address"]]
                                      name:[cafeteria objectForKey:@"name"]
                                      address:[cafeteria objectForKey:@"address"]
                                        andID: [cafeteria objectForKey:@"id"]];
            [mapView addAnnotation:pin];

        }
        
        app.networkActivityIndicatorVisible = NO;
        [self performSelector:@selector(updateMap) withObject:nil afterDelay:180];   //Refresh every three minutes
        
        
    } else {
        
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

#pragma mark -
#pragma mark MKMapViewDelegate protocol

- (void)mapView:(MKMapView *)theMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [theMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.25;
    span.longitudeDelta = 0.25;
    
    
    CLLocationCoordinate2D location = [[userLocation location] coordinate];

    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:YES];

}

-(void)mapView:(MKMapView *)fMapView regionDidChangeAnimated:(BOOL)animated {
    //[self updateMap];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
   NSNumber *cafeteriaID = [(AddressAnnotation*) [view annotation] cafeteriaID];
    
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


@end
