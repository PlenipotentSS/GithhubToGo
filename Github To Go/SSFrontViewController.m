//
//  SSDetailViewController.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSFrontViewController.h"
#import "SSSplitViewController.h"
#import "SSGitHubRepo.h"

@interface SSFrontViewController () 

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation SSFrontViewController

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

-(void)viewWillDisappear:(BOOL)animated {
}

-(NSURL*) applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        NSString *html_string;
        if ([self.detailItem valueForKey:@"html_string"]) {
            html_string = [self.detailItem valueForKey:@"html_string"];
            [self.detailWebView loadHTMLString:html_string baseURL:[self applicationDocumentsDirectory]];
        } else {
            NSString *htmlURLString = [self.detailItem html_url];
            html_string = [NSString stringWithContentsOfURL:[NSURL URLWithString:htmlURLString] encoding:NSUTF8StringEncoding error:nil];
            [self.detailWebView loadHTMLString:html_string baseURL:[self applicationDocumentsDirectory]];
        }
        
        if ([self.detailItem isKindOfClass:[SSGitHubRepo class]]) {
            SSGitHubRepo *repo = (SSGitHubRepo*)self.detailItem;
            repo.html_string = html_string;
            
            [self.navigationItem setTitle:[repo title]];
        } else {
            SSGitHubUser *user = (SSGitHubUser*)self.detailItem;
            user.html_string = html_string;
            
            [self.navigationItem setTitle:[self.detailItem name]];
        }
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
    
    [self.detailWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/trending"]]];
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
    if ([(SSSplitViewController*)self.parentViewController.parentViewController menuStateInView] == MenuCompletelyHidden) {
        [(SSSplitViewController*)self.parentViewController.parentViewController showMenuSplit];
    } else if ([(SSSplitViewController*)self.parentViewController.parentViewController menuStateInView] == MenuOpened) {
        [(SSSplitViewController*)self.parentViewController.parentViewController hideMenu];
    }
}
@end
