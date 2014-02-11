//
//  SSGitHubUser.m
//  Github To Go
//
//  Created by Stevenson on 1/28/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSGitHubUser.h"

@implementation SSGitHubUser

@dynamic name;
@dynamic html_url;
@dynamic imageURLString;
@synthesize html_string = _html_string;
@dynamic isDownloading;
@synthesize userImage;

-(void)downloadUserAvatar
{
    self.isDownloading = YES;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[self imageURLString]]];
    self.userImage = [UIImage imageWithData:imageData];
    self.isDownloading = NO;
}

-(id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withJsonDictionary:(NSDictionary*)json
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self) {
        [self parseJsonDictionary:json];
    }
    return self;
}

-(void) setHtml_string:(NSString *)html_string
{
    _html_string = html_string;
    [self.managedObjectContext save:nil];
}

-(void) parseJsonDictionary:(NSDictionary *) json
{
    self.name = json[@"login"];
    self.html_url = json[@"html_url"];
    self.imageURLString = json[@"avatar_url"];
    [self.managedObjectContext save:nil];
}

@end
