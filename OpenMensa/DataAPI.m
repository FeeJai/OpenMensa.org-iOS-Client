//
//  DataAPI.m
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import "DataAPI.h"

@implementation DataAPI

// Singleton instance and method
static DataAPI *pInstance = nil;

+(DataAPI *)instance {
    @synchronized(self) {
        if (pInstance == nil) pInstance = [[self alloc] init];
    }
    return pInstance;
}

@end
