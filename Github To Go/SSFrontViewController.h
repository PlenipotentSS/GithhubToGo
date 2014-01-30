//
//  SSDetailViewController.h
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSGitHubUser.h"
@class SSSplitViewController;

@interface SSFrontViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) SSGitHubUser *detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;

- (void)configureView;

@end
