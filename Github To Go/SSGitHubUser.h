//
//  SSGitHubUser.h
//  Github To Go
//
//  Created by Stevenson on 1/28/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSGitHubUser : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imageURLString;
@property (nonatomic) NSString *html_url;
@property (nonatomic) UIImage *userImage;
@property (nonatomic) BOOL isDownloading;

-(void)downloadUserAvatar;

@end
