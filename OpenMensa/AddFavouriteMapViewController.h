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

#import "DataAPI.h"

@interface AddressAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *name;
    NSString *address;
    NSNumber *cafeteriaID;
}

@property(nonatomic,retain) NSNumber *cafeteriaID;


@end


@interface AddFavouriteMapViewController : UIViewController <MKMapViewDelegate> {
    DataAPI *api;
    MKMapView *mapView;
}


-(CLLocationCoordinate2D)findCoordinatesForAddress:(NSString*) address;
-(void)updateMap;

@end