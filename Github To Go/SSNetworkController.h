//
//  SSNetworkController.h
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSNetworkController : NSObject

+ (SSNetworkController*) sharedController;

- (void)reposForSearchString: (NSString *) searchString andCompletion:(void(^)(NSArray* result))callback;

-(void)usersForSearchString: (NSString*) searchString andCompletion:(void(^)(NSArray* result))callback;

@end
