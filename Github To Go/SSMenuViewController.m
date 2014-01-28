//
//  SSMenuViewController.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSMenuViewController.h"
#import "SSDetailViewController.h"
#import "SSMasterViewController.h"

#define Menu_Offset 40.f

@interface SSMenuViewController () <UIGestureRecognizerDelegate>

@end

@implementation SSMenuViewController

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
    self.viewCover = DetailViewCompletelyVisible;

}

-(void) setupSubNavControllers {
    self.menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
    [self.view addSubview:self.menuController.view];
    SSMasterViewController *menuVC = (SSMasterViewController*)[[self.menuController viewControllers] firstObject];
    
    self.menuController.view.frame = CGRectMake(-Menu_Offset, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    self.detailViewController = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    [self.view addSubview:self.detailViewController.view];
    self.detailViewController.view.frame = self.view.frame;
    
    SSDetailViewController *detailVC = (SSDetailViewController*)[[self.detailViewController viewControllers] firstObject];
    
    [menuVC setDetailViewController:detailVC];
    [menuVC setTheSplitController:self];
    [detailVC setTheSplitController:self];
    
    self.detailViewController.navigationController.navigationBar.hidden = NO;
    
    [self addChildViewController:self.detailViewController];
    self.detailViewController.view.frame = self.view.frame;
    [self.detailViewController didMoveToParentViewController:self];
    
    [self.detailViewController.view.layer setShadowOpacity:0.8f];
    [self.detailViewController.view.layer setShadowOffset:CGSizeMake(-1,0)];
}

-(void)setupPanGesture {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel:)];
    
    pan.minimumNumberOfTouches = 1;
    pan.maximumNumberOfTouches = 1;
    
    pan.delegate = self;
    
    [self.detailViewController.view addGestureRecognizer:pan];
}

#pragma mark - top view controller motions from menu
-(void)shiftDetailToHideFull {
    [UIView animateWithDuration:.4f animations:^{
        self.detailViewController.view.frame= CGRectMake(CGRectGetWidth(self.view.frame), 0.f, CGRectGetWidth(self.detailViewController.view.frame), CGRectGetHeight(self.detailViewController.view.frame));
        self.menuController.view.frame = CGRectMake(0, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    self.viewCover = DetailViewCompletelyHidden;
}

-(void)shiftDetailToPartialHide {
    [UIView animateWithDuration:.4f animations:^{
        self.detailViewController.view.frame= CGRectMake(CGRectGetWidth(self.view.frame)*.8, 0.f, CGRectGetWidth(self.detailViewController.view.frame), CGRectGetHeight(self.detailViewController.view.frame));
        self.menuController.view.frame = CGRectMake(0, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    self.viewCover = DetailViewMostlyHidden;
}

-(void)shiftDetailToShowFull {
    [UIView animateWithDuration:.4f animations:^{
        self.detailViewController.view.frame= CGRectMake(0.f, 0.f, CGRectGetWidth(self.detailViewController.view.frame), CGRectGetHeight(self.detailViewController.view.frame));
        self.menuController.view.frame = CGRectMake(-Menu_Offset, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    self.viewCover = DetailViewCompletelyVisible;
}

#pragma mark - pan Gesture Actions
-(void)slidePanel:(id) sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    //CGPoint velocity = [pan velocityInView:pan.view];
    CGPoint translation = [pan translationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    
    if (pan.state ==UIGestureRecognizerStateChanged) {
        if (self.detailViewController.view.frame.origin.x+translation.x >= 0) {
            self.detailViewController.view.center = CGPointMake(self.detailViewController.view.center.x+translation.x, self.detailViewController.view.center.y);
            
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0, 0) inView:self.view];
        }
        
        

        if (self.menuController.view.frame.origin.x >= -Menu_Offset && self.menuController.view.frame.origin.x <= 0.f) {
            CGFloat menuTranslation = self.menuController.view.center.x+translation.x*Menu_Offset/320;
            if (menuTranslation > self.view.center.x) {
                menuTranslation = self.view.center.x;
            }
            self.menuController.view.center = CGPointMake(menuTranslation, self.detailViewController.view.center.y);
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if ((self.detailViewController.view.frame.origin.x <= self.view.frame.size.width/2 && velocity.x < 1200.f) || velocity.x <-1200.f ) {
            [UIView animateWithDuration:.4f animations:^{
                self.detailViewController.view.center = self.view.center;
                self.menuController.view.frame = CGRectMake(-Menu_Offset, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            }];
            self.viewCover = DetailViewCompletelyVisible;
        } else if (velocity.x >= 1200.f || self.detailViewController.view.frame.origin.x > self.view.frame.size.width/2) {
            
            [UIView animateWithDuration:.4f animations:^{
                self.detailViewController.view.frame = CGRectMake(CGRectGetWidth(self.view.frame)*0.8f, CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                self.menuController.view.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            }];
            
            self.viewCover = DetailViewMostlyHidden;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
