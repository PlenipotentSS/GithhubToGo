//
//  SSMenuViewController.h
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum CoverState{
    DetailViewCompletelyHidden,
    DetailViewMostlyHidden,
    DetailViewCompletelyVisible
}CoverState;

@interface SSMenuViewController : UIViewController

@property (nonatomic) CoverState viewCover;

@property (strong, nonatomic) UINavigationController *detailViewController;
@property (strong, nonatomic) UINavigationController *menuController;

-(void)shiftDetailToHideFull;
-(void)shiftDetailToPartialHide;
-(void)shiftDetailToShowFull;

@end
