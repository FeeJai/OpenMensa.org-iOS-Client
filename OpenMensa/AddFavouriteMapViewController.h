//
//  SecondViewController.h
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>


@interface AddressAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *name;
    NSString *address;
}

@end


@interface AddFavouriteMapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
    NSString *name;
    NSString *address;
    AddressAnnotation *pin;
    CLLocationCoordinate2D location;
}


-(void)showAddress;
-(void)findLocation;

@end