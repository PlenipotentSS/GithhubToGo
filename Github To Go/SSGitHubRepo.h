//
//  SSGitHubRepo.h
//  Github To Go
//
//  Created by Stevenson on 2/11/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SSGitHubRepo : NSManagedObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *imageURLString;
@property (nonatomic) NSString *html_url;
@property (nonatomic) UIImage *userImage;
@property (nonatomic) BOOL isDownloading;

-(id) initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context withJsonDictionary:(NSDictionary*)json;
-(void)downloadUserAvatar;
-(void) parseJsonDictionary:(NSDictionary *) json;

@end
