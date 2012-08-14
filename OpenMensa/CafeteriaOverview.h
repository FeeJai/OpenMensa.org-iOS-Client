//
//  FirstViewController.h
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataAPI; //Forward declaration to allow import of DataAPI.h which imports MainScreenViewController.h

#import "FavouriteCafeteriaStorage.h"
#import "DataAPI.h"


@interface CafeteriaOverview : UITableViewController < UITableViewDelegate, UITableViewDataSource, DataAPIDelegate > {
    IBOutlet UITableView *table;

    DataAPI *api;
    FavouriteCafeteriaStorage *favourites;
}


@end
