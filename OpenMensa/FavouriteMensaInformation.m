//
//  FavouriteMensaInformation.m
//  OpenMensa
//
//  Created by Felix Jankowski on 04.07.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import "FavouriteMensaInformation.h"

@implementation FavouriteMensaInformation


// Singleton instance and method
static FavouriteMensaInformation *pInstance = nil;

+(FavouriteMensaInformation *)instance {
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
    
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSArray arrayWithArray:favouriteCafeterias] forKey:@"favouriteCafeterias"];

}

-(NSArray *) favouriteCafeterias {
    return [NSArray arrayWithArray:favouriteCafeterias];
}


@end
