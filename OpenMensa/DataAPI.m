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

#pragma mark API Calls

- (NSDictionary *) getData {
    NetworkController *network = [[NetworkController alloc] init];
    [network getDataFor:self];
    
    return nil;
}


- (void) APIDataReceived:(NSString *)APIData {
    
    //NSLog(@"Response: %@",APIData);
    NSError *error = nil;


    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];

    id jsonObject = [jsonParser objectWithString:APIData error:&error];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        
        for (NSDictionary* jsonMensa in jsonObject) {
                //NSDictionary* jsonMensa = (NSDictionary *) object;
            [jsonMensa objectForKey:@"name"];
            [jsonMensa objectForKey:@"address"];
        }

    } //Else: somethine went wrong

    if(error)
        NSLog(@"The following error occured: %@", error);

}

@end
