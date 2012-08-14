//
//  DataAPI.h
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"


#import "NetworkController.h"


//*** THIS IS THE IMPLEMENTATION FOR THE V1 API - NEEDS TO BE UPDATED ONCE FUNCTIONALITY IS AVAILABLE

// DataAPI is a Singleton!
@interface DataAPI : NSObject <NetworkDataUpdateProtocol> {
    
    
}

// Returns the singleton instance
+(DataAPI *)instance;

- (NSDictionary *) getData;

@end
