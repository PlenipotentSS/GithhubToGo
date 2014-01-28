//
//  SSDetailViewController.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSDetailViewController.h"
#import "SSMenuViewController.h"

@interface SSDetailViewController () 

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation SSDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        NSString *htmlURLString = [self.detailItem objectForKey:@"html_url"];
        [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:htmlURLString]]];
        [self.navigationItem setTitle:[self.detailItem objectForKey:@"name"]];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds));
    } else {
        self.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), CGRectGetMinY(self.view.frame), CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds));
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
    
        self.navigationItem.leftBarButtonItem = menuButton;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    [barButtonItem setImage:[UIImage imageNamed:@"menu.png"]];
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Split Controller (custom menu)
-(void)showMenu {
    if (self.theSplitController.viewCover == DetailViewCompletelyVisible) {
        [self.theSplitController shiftDetailToPartialHide];
    } else {
        [self.theSplitController shiftDetailToShowFull];
    }
}

@end
