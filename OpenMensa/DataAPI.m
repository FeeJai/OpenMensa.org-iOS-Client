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

- (NSDictionary *) getData {
    return nil;
}

- (void) APIDataReceived:(NSString *)APIData {
    
    SBJsonParser *parser = [SBJsonParser alloc];

    NSArray *object = [parser objectWithString:APIData error:nil];
    
    for (NSDictionary *status in object)
    {
        // You can retrieve individual values using objectForKey on the status NSDictionary
        // This will print the tweet and username to the console
        NSLog(@"%@ - %@", [status objectForKey:@"text"], [[status objectForKey:@"user"] objectForKey:@"screen_name"]);
    }
}

@end
