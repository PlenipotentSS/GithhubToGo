//
//  SSUserCollectionAvatarCell.m
//  Github To Go
//
//  Created by Stevenson on 1/28/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSUserCollectionAvatarCell.h"

@implementation SSUserCollectionAvatarCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void) configureCell {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

@end
