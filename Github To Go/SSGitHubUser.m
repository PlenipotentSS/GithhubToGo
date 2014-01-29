//
//  SSGitHubUser.m
//  Github To Go
//
//  Created by Stevenson on 1/28/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSGitHubUser.h"

@implementation SSGitHubUser

-(void)downloadUserAvatar
{
    _isDownloading = YES;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self imageURLString]]];
    _userImage = [UIImage imageWithData:imageData];
    _isDownloading = NO;
}

@end
