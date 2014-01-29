//
//  SSMenuViewController.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSSplitViewController.h"
#import "SSFrontViewController.h"
#import "SSBackViewController.h"

#define Menu_Offset 40.f

@interface SSSplitViewController () <UIGestureRecognizerDelegate>

@end

@implementation SSSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:(NSBundle *)nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //setup navigation controller pointers
    [self setupSubNavControllers];
    
    //setup pan gesture recognizers
    [self setupPanGesture];
    
    //set the current relationship cover
    self.menuStateInView = MenuCompletelyHidden;

}

-(void) setupSubNavControllers {
    self.backViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
    [self.view addSubview:self.backViewController.view];
    SSBackViewController *menuVC = (SSBackViewController*)[[self.backViewController viewControllers] firstObject];
    
    //self.menuController.view.frame = CGRectMake(-Menu_Offset, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    self.frontViewController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    [self.view addSubview:self.frontViewController.view];
    
    SSFrontViewController *detailVC = (SSFrontViewController*)[[self.frontViewController viewControllers] firstObject];
    
    [menuVC setDetailViewController:detailVC];
    [menuVC setTheSplitController:self];
    [detailVC setTheSplitController:self];
    
    self.frontViewController.navigationController.navigationBar.hidden = NO;
    
    [self addChildViewController:self.frontViewController];
    //self.detailViewController.view.frame = self.view.frame;
    [self.frontViewController didMoveToParentViewController:self];
    
    [self.frontViewController.view.layer setShadowOpacity:0.8f];
    [self.frontViewController.view.layer setShadowOffset:CGSizeMake(-1,0)];
}

-(void)setupPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    
    pan.delegate = self;
    
    [self.frontViewController.view addGestureRecognizer:pan];
}


#pragma mark - top view controller motions from menu
-(void)showMenuFullScreen {
    [UIView animateWithDuration:.4f animations:^{
        self.frontViewController.view.frame= CGRectMake(CGRectGetWidth(self.view.frame), 0.f, CGRectGetWidth(self.frontViewController.view.frame), CGRectGetHeight(self.frontViewController.view.frame));
        self.backViewController.view.frame = CGRectMake(0, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    self.menuStateInView = MenuCompletelyOpened;
}

-(void)showMenuSplit {
    [UIView animateWithDuration:.4f animations:^{
        self.frontViewController.view.frame= CGRectMake(CGRectGetWidth(self.view.frame)-(.2*CGRectGetWidth(self.view.frame)), 0.f, CGRectGetWidth(self.frontViewController.view.frame), CGRectGetHeight(self.frontViewController.view.frame));
        self.backViewController.view.frame = CGRectMake(0, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    self.menuStateInView = MenuOpened;
}

-(void)hideMenu {
    [UIView animateWithDuration:.4f animations:^{
        self.frontViewController.view.frame= CGRectMake(0.f, 0.f, CGRectGetWidth(self.frontViewController.view.frame), CGRectGetHeight(self.frontViewController.view.frame));
        self.backViewController.view.frame = CGRectMake(-Menu_Offset, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    self.menuStateInView = MenuCompletelyHidden;
}


#pragma mark - pan Gesture Actions
-(void)slidePanel:(id) sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    //CGPoint velocity = [pan velocityInView:pan.view];
    CGPoint translation = [pan translationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    if (pan.state ==UIGestureRecognizerStateChanged) {
        if (self.frontViewController.view.frame.origin.x+translation.x >= 0) {
            self.frontViewController.view.center = CGPointMake(self.frontViewController.view.center.x+translation.x, self.frontViewController.view.center.y);
            
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0, 0) inView:self.view];
        }
        
        

        if (self.backViewController.view.frame.origin.x >= -Menu_Offset && self.backViewController.view.frame.origin.x <= 0.f) {
            CGFloat menuTranslation = self.backViewController.view.center.x+translation.x*Menu_Offset/320;
            if (menuTranslation > self.view.center.x) {
                menuTranslation = self.view.center.x;
            }
            self.backViewController.view.center = CGPointMake(menuTranslation, self.frontViewController.view.center.y);
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if ((self.frontViewController.view.frame.origin.x <= self.view.frame.size.width/2 && velocity.x < 1200.f) || velocity.x <-1200.f ) {
            [UIView animateWithDuration:.4f animations:^{
                self.frontViewController.view.center = self.view.center;
                self.backViewController.view.frame = CGRectMake(-Menu_Offset, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            }];
            self.menuStateInView = MenuCompletelyHidden;
        } else if (velocity.x >= 1200.f || self.frontViewController.view.frame.origin.x > self.view.frame.size.width/2) {
            
            [UIView animateWithDuration:.4f animations:^{
                self.frontViewController.view.frame = CGRectMake(CGRectGetWidth(self.view.frame)*0.8f, CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                self.backViewController.view.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            }];
            
            self.menuStateInView = MenuOpened;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
