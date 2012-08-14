//
//  FavouriteMensaInformation.m
//  OpenMensa
//
//  Created by Felix Jankowski on 04.07.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import "FavouriteCafeteriaStorage.h"

@implementation FavouriteCafeteriaStorage


// Singleton instance and method
static FavouriteCafeteriaStorage *pInstance = nil;

+(FavouriteCafeteriaStorage *)instance {
    @synchronized(self) {
        if (pInstance == nil) pInstance = [[self alloc] init];
    }
    return pInstance;
}


-(id)init {
    self = [super init];
        
    NSArray* storedFavouriteCafeterias = [[NSUserDefaults standardUserDefaults] objectForKey:@"favouriteCafeterias"];
    
    if (storedFavouriteCafeterias == nil)
        favouriteCafeterias = [[NSMutableArray alloc] init];
    else
        favouriteCafeterias = [NSMutableArray arrayWithArray:storedFavouriteCafeterias];

    return self;
}



-(bool) cafeteriaIsFavourite: (NSNumber*) cafeteriaId {
    
    bool favourite = false;
    
    for (NSNumber *currentCafeteria in favouriteCafeterias) {
        
        if ([currentCafeteria isEqualToNumber:cafeteriaId]) {
            favourite = true;
            break;
        }
        
    }
    
    return favourite;
    
}


-(void) addFavouriteCafeteria: (NSNumber*) cafeteriaId {
    
    if(![self cafeteriaIsFavourite:cafeteriaId]) {
        
        [favouriteCafeterias addObject:cafeteriaId];
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:favouriteCafeterias] forKey:@"favouriteCafeterias"];

        NSLog(@"Added cafeteria %@ to local favourites", cafeteriaId);
        
    }
}

-(void) removeFavouriteCafeteria: (NSNumber*) cafeteriaId {
    
    [favouriteCafeterias removeObjectAtIndex:[cafeteriaId intValue]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:favouriteCafeterias] forKey:@"favouriteCafeterias"];
    
    NSLog(@"Removed cafeteria %@ from local favourites", cafeteriaId);

}

- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{

}


-(void) moveCafeteria: (NSNumber*) cafeteriaIndex toPlace:(NSNumber*) newIndex {

    NSUInteger from = [cafeteriaIndex integerValue];
    NSUInteger to = [newIndex integerValue];

    if (to != from) {
        id obj = [favouriteCafeterias objectAtIndex:from];
        [favouriteCafeterias removeObjectAtIndex:from];
        if (to >= [favouriteCafeterias count]) {
            [favouriteCafeterias addObject:obj];
        } else {
            [favouriteCafeterias insertObject:obj atIndex:to];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:favouriteCafeterias] forKey:@"favouriteCafeterias"];
    
}


-(NSNumber*) cafeteriaIdAtIndex:(NSUInteger)index {
    return [favouriteCafeterias objectAtIndex:index];
}


-(NSArray *) favouriteCafeterias {
    return [NSArray arrayWithArray:favouriteCafeterias];
}


@end
