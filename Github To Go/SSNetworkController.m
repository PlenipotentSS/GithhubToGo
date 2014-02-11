//
//  SSNetworkController.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSNetworkController.h"
@interface SSNetworkController()

@property (nonatomic) NSOperationQueue *downloadQueue;

@end

@implementation SSNetworkController


+(SSNetworkController*) sharedController {
    static dispatch_once_t pred;
    static SSNetworkController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[SSNetworkController alloc] init];
        shared.downloadQueue = [NSOperationQueue new];
        
    });
    
    return shared;
}

- (void)reposForSearchString: (NSString *) searchString andCompletion:(void(^)(NSArray* result))callback{
    //search string is iOS
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@&sort=stars&order=desc", searchString];
    NSURL *url = [NSURL URLWithString:searchString];
    
    
    [self.downloadQueue addOperationWithBlock:^{
        NSError *error;
        NSData *searchData = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if (!error) {
            NSDictionary *searchDict = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    callback([searchDict objectForKey:@"items"]);
                }];
            } else {
                
                NSLog(@"error: %@",error);
            }
        } else {
            NSLog(@"error: %@",error);
        }
        
    }];
}

-(void)usersForSearchString: (NSString*) searchString andCompletion:(void(^)(NSArray* result))callback {
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    searchString  = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@&sort=stars", searchString];
    NSURL *url = [NSURL URLWithString:searchString];
    
    
    [self.downloadQueue addOperationWithBlock:^{
        NSError *error;
        NSData *searchData = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if (!error) {
            NSDictionary *searchDict = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    callback([searchDict objectForKey:@"items"]);
                }];
            } else {
                
                NSLog(@"error: %@",error);
            }
        } else {
            NSLog(@"error: %@",error);
        }
    }];
}

@end
