//
//  ShowMenuNavigationControllerViewController.h
//  OpenMensa
//
//  Created by Felix Jankowski on 14.08.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataAPI.h"
#import "CafeteriaOverview.h"

@interface ShowMenuNavigationController : UINavigationController < DataAPIDelegate > {
    CafeteriaOverview *firstView;
}

@end
