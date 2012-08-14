//
//  FavouriteMensaInformation.h
//  OpenMensa
//
//  Created by Felix Jankowski on 04.07.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import <Foundation/Foundation.h>

//This class stores the favourite cafeterias locally on the phone in an Array. The permanent storage is in an NSArray which is not writeable, changes are done on an NSMutableArray which is created on init


@interface FavouriteCafeteriaStorage : NSObject {
    
    NSMutableArray* favouriteCafeterias;
}


// Returns the singleton instance
+(FavouriteCafeteriaStorage *)instance;

-(bool) cafeteriaIsFavourite: (NSNumber*) cafeteriaId;
-(void) addFavouriteCafeteria: (NSNumber*) cafeteriaId;
-(NSArray *) favouriteCafeterias;
 
@end
