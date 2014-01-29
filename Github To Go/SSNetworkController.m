//
//  SSNetworkController.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSNetworkController.h"

@implementation SSNetworkController


+(SSNetworkController*) sharedController {
    static dispatch_once_t pred;
    static SSNetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[SSNetworkController alloc] init];
        
    });
    
    return shared;
}

- (NSArray *)reposForSearchString: (NSString *) searchString {
    //search string is iOS
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@&sort=stars&order=desc", searchString];
    NSURL *url = [NSURL URLWithString:searchString];
    NSError *error;
    NSData *searchData = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (!error) {
        NSDictionary *searchDict = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            
            return [searchDict objectForKey:@"items"];
        } else {
            
            NSLog(@"error: %@",error);
        }
    } else {
        NSLog(@"error: %@",error);
    }

    return [NSArray new];
}

-(NSArray *)usersForSearchString: (NSString*) searchString {
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    searchString  = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@&sort=stars", searchString];
    NSURL *url = [NSURL URLWithString:searchString];
    NSError *error;
    NSData *searchData = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (!error) {
        NSDictionary *searchDict = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            
            return [searchDict objectForKey:@"items"];
        } else {
            
            NSLog(@"error: %@",error);
        }
    } else {
        NSLog(@"error: %@",error);
    }
    
    return [NSArray new];
}

@end
