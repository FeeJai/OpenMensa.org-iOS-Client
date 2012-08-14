//
//  DataAPI.m
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import "DataAPI.h"

@implementation DataAPI

@synthesize cafeterias, lastUpdate, delegate;

// Singleton instance and method
static DataAPI *pInstance = nil;

+(DataAPI *)instance {
    @synchronized(self) {
        if (pInstance == nil) pInstance = [[self alloc] init];
    }
    return pInstance;
}


-(id)init {
    self = [super init];
    
    cafeterias = [[NSMutableArray alloc] init];
    lastUpdate = nil;
    delegate = nil;
    
    return self;
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
    NSMutableArray *cafeteriasUnsorted = [[NSMutableArray alloc]init];


    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];

    id jsonObject = [jsonParser objectWithString:APIData error:&error];
    
    if ([jsonObject isKindOfClass:[NSArray class]]) {
        
        for (NSDictionary* jsonMensa in jsonObject) {
                //NSDictionary* jsonMensa = (NSDictionary *) object;
            //[cafeterias insertObject:[jsonMensa objectForKey:@"cafeteria"] atIndex:nil];
            [cafeteriasUnsorted addObject:[jsonMensa objectForKey:@"cafeteria"]];
            
        }

    } //Else: somethine went wrong

    //All cafeterias added, now sort the array based on the id parameter;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];

    //Save the cafeterias for access and set the last update to the current date
    cafeterias = [cafeteriasUnsorted sortedArrayUsingDescriptors:sortDescriptors];
    lastUpdate = [NSDate date];
    [delegate APIDataHasBeenUpdated];
    

    if(error)
        NSLog(@"The following error occured: %@", error);

}

@end
