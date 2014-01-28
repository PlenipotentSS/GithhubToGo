//
//  SSDetailViewController.h
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SSMenuViewController;

@interface SSDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;


@property (nonatomic) SSMenuViewController *theSplitController;

- (void)configureView;

@end
