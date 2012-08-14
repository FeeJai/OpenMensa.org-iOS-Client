//
//  SecondViewController.m
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import "AddFavouriteMapViewController.h"


@implementation AddressAnnotation

@synthesize coordinate;


-(NSString *)subtitle {
    return address;
}


-(NSString *)title {
    return name;
}


-(id)initWithCoordinate:(CLLocationCoordinate2D)c name:(NSString *)fName andAddress:(NSString *)fAddress {
    coordinate = c;
    name = fName;
    address = fAddress;
    
    return self;
}

@end

#pragma mark -


@implementation AddFavouriteMapViewController



-(void)showAddress {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:YES];
}


-(void)findLocation {
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
    location.latitude = latitude;
    location.longitude = longitude;
    
}



-(void)updateMap {
    
    NSDate *lastAPIpdate = [api lastUpdate];
    UIApplication* app = [UIApplication sharedApplication];

    if (lastAPIpdate && ([lastAPIpdate timeIntervalSinceNow] > -60)) {    //Data was received within the last 60 seconds

        NSLog(@"%lf",[lastAPIpdate timeIntervalSinceNow]);
        app.networkActivityIndicatorVisible = NO;
        [self performSelector:@selector(updateMap) withObject:nil afterDelay:180];   //Refresh every three minutes
        
    } else {
        
        //Make API refresh data and try again in 10 seconds
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
    
    
    pin = nil;
    api = [DataAPI instance];
    
    mapView = [[MKMapView alloc] init];
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    
    self.view = mapView;
    
    
    //Test
    /*
    name = @"abc";
    address = @"Rudolf-Breitscheid-Str. 47, 14482 Potsdam";
    
    [self findLocation];
    [self showAddress];
    */
    
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
    
    
    location = [[userLocation location] coordinate];

    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:YES];

}

-(void)mapView:(MKMapView *)fMapView regionDidChangeAnimated:(BOOL)animated {
    if (pin != nil) return;
    pin = [[AddressAnnotation alloc] initWithCoordinate:location name:name andAddress:address];
    [fMapView addAnnotation:pin];
}


-(MKAnnotationView *) mapView:(MKMapView *)fMapView viewForAnnotation:(id <MKAnnotation>) annotation{
    if (annotation == mapView.userLocation) {
        return nil; // default to blue dot
    }
    MKPinAnnotationView *annView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    annView.pinColor = MKPinAnnotationColorRed;
    annView.animatesDrop = YES;
    annView.canShowCallout = YES;
    return annView;
}


@end
