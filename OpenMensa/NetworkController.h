//
//  NetworkController.h
//  OpenMensa
//
//  Created by Felix Jankowski on 12.06.12.
//  Copyright (c) 2012 openmensa.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkDataUpdateProtocol;


@interface NetworkController : NSObject <NSURLConnectionDataDelegate> {
    NSURLRequest *theRequest;
    NSURLConnection *theConnection;
	NSMutableData *receivedData;
    
    id <NetworkDataUpdateProtocol> delegate;

}

-(void) getDataFor: (id) delegate ;

@property(nonatomic,retain) NSMutableData *receivedData;

@end


@protocol NetworkDataUpdateProtocol

- (void)APIDataReceived:(NSString *)APIData;

@end
