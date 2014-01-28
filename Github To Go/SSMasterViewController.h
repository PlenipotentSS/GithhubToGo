//
//  SSMasterViewController.h
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSDetailViewController.h"
@class SSMenuViewController;

@interface SSMasterViewController : UIViewController

@property (nonatomic) SSDetailViewController *detailViewController;
@property (nonatomic) SSMenuViewController *theSplitController;

@end
