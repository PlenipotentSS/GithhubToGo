//
//  SSGitHubRepo.m
//  Github To Go
//
//  Created by Stevenson on 2/11/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSGitHubRepo.h"
#import "SSGitHubUser.h"


@implementation SSGitHubRepo

@dynamic title;
@dynamic name;
@dynamic html_url;
@dynamic imageURLString;
@synthesize userImage;
@synthesize html_string = _html_string;
@dynamic isDownloading;


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
    self.name = json[@"owner"][@"login"];
    self.html_url = json[@"html_url"];
    self.title = json[@"name"];
    self.imageURLString = json[@"owner"][@"avatar_url"];
    [self.managedObjectContext save:nil];
}


@end
