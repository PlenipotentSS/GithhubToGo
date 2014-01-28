//
//  SSMenuViewController.h
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSDetailViewController.h"
#import "SSMasterViewController.h"

@interface SSMenuViewController : UIViewController

@property (strong, nonatomic) UINavigationController *detailViewController;
@property (strong, nonatomic) SSMasterViewController *menuController;

@end
