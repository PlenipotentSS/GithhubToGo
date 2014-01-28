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

- (NSArray *)reposForSearchString: (NSString *) searchString;

@end
