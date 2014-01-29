//
//  SSUserCollectionAvatarCell.h
//  Github To Go
//
//  Created by Stevenson on 1/28/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSUserCollectionAvatarCell : UICollectionViewCell

@property (nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic) IBOutlet UILabel *name;

-(void)configureCell;

@end
