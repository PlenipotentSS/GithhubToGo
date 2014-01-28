//
//  SSMenuViewController.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSMenuViewController.h"

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

    self.menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"menu"];
    [self.view addSubview:self.menuController.view];
    
    UINavigationController *detailNav = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    self.detailViewController = detailNav;
    
    self.detailViewController.navigationController.navigationBar.hidden = NO;
    
    [self addChildViewController:self.detailViewController];
    self.detailViewController.view.frame = self.view.frame;
    [self.view addSubview:self.detailViewController.view];
    [self.detailViewController didMoveToParentViewController:self];
    
    [self setupPanGesture];
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


#pragma mark - pan Gesture Actions
-(void)slidePanel:(id) sender {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)sender;
    
    //CGPoint velocity = [pan velocityInView:pan.view];
    CGPoint translation = [pan translationInView:self.view];
    
    //NSLog(@"x: %f y: %f",translation.x,translation.y);
    
    if (pan.state ==UIGestureRecognizerStateChanged) {
        if (self.detailViewController.view.frame.origin.x+translation.x >= 0) {
            self.detailViewController.view.center = CGPointMake(self.detailViewController.view.center.x+translation.x, self.detailViewController.view.center.y);
            
            [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0, 0) inView:self.view];
        }
        
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.detailViewController.view.frame.origin.x <= self.view.frame.size.width/2) {
            [UIView animateWithDuration:.4f animations:^{
                self.detailViewController.view.center = self.view.center;
                //[self.detailViewController.view setAlpha:1];
            }];
        } else if (self.detailViewController.view.frame.origin.x > self.view.frame.size.width/2) {
            
            [UIView animateWithDuration:.4f animations:^{
                self.detailViewController.view.frame = CGRectMake(CGRectGetWidth(self.view.frame)*0.8f, CGRectGetMinY(self.view.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                //[self.detailViewController.view setAlpha:.2];
            } completion:^(BOOL finished){
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideBack:)];
                [self.detailViewController.view addGestureRecognizer:tap];
            }];
            
        }
    }
}

-(void)slideBack:(id)sender {
    [UIView animateWithDuration:.4f animations:^{
        self.detailViewController.view.frame = self.view.frame;
        //[self.detailViewController.view setAlpha:1];
    } completion:^(BOOL finished) {
        [self.detailViewController.view removeGestureRecognizer:(UITapGestureRecognizer*)sender];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
