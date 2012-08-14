//
//  FoodOverwievController.h
//  OpenMensa
//
//  Created by Felix Jankowski on 14.08.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAPI.h"

@interface FoodOverwievController : UITableViewController {    
    DataAPI *api;
    NSDictionary *cafeteria;
    
    NSMutableArray *foodToday;
    NSMutableArray *foodTomorrow;

}

-(id) initWithCafeteria: (NSDictionary*) cafeteria;
@end
