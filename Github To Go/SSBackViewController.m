//
//  SSMasterViewController.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSBackViewController.h"
#import "SSNetworkController.h"
#import "SSFrontViewController.h"
#import "SSSearchCollectionView.h"
#import "SSSplitViewController.h"

#import "SSGitHubUser.h"
#import "SSGitHubRepo.h"

#import "SSUserCollectionAvatarCell.h"
#import "SSRepoCollectionCell.h"

@interface SSBackViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (nonatomic) NSMutableArray *repos;
@property (nonatomic) NSMutableArray *usersArray;
@property (nonatomic) IBOutlet SSSearchCollectionView *theCollectionView;
@property (nonatomic) IBOutlet UITextField *searchField;
@property (nonatomic) IBOutlet UISegmentedControl *searchSwitch;

@property (nonatomic) NSMutableArray *searches;

@property (nonatomic) BOOL isSearchingUsers;

@property (nonatomic) NSOperationQueue *downloadImagesQueue;

@end

@implementation SSBackViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.repos = [[NSMutableArray alloc] init];
    self.usersArray = [[NSMutableArray alloc] init];
    self.searchField.delegate = self;
    self.theCollectionView.delegate = self;
    self.theCollectionView.dataSource = self;
    
    self.searches = [[NSMutableArray alloc] initWithObjects:@"",@"", nil];
    
    self.downloadImagesQueue = [NSOperationQueue new];
    
    self.searchSwitch.selectedSegmentIndex= 1;
    self.searchSwitch.layer.cornerRadius = 2;
    self.searchSwitch.layer.masksToBounds = YES;
    [self.searchSwitch addTarget:self action:@selector(switchSearchType:) forControlEvents:UIControlEventValueChanged];
    self.searchSwitch.center = CGPointMake(self.searchField.center.x, self.searchSwitch.center.y);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController = (SSFrontViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesBeganOnTableView) name:@"TouchOccurredOnTableView" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([self.searchField isFirstResponder]) {
        [self.searchField resignFirstResponder];
        self.searchField.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - searchSwitch
-(void)switchSearchType:(id)sender{
    UISegmentedControl *thisSwitch = (UISegmentedControl*)sender;
    if ( thisSwitch.selectedSegmentIndex == 0 ) {
        self.theCollectionView.frame = CGRectMake(CGRectGetMinX(self.theCollectionView.frame), CGRectGetMinY(self.theCollectionView.frame), 260.f, CGRectGetHeight(self.theCollectionView.frame));
        self.searchField.text = self.searches[0];
        self.isSearchingUsers = YES;
    } else {
        self.theCollectionView.frame = CGRectMake(CGRectGetMinX(self.theCollectionView.frame), CGRectGetMinY(self.theCollectionView.frame), 320.f, CGRectGetHeight(self.theCollectionView.frame));
        self.searchField.text = self.searches[1];
        self.isSearchingUsers = NO;
    }
    [self.theCollectionView reloadData];
}


#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length] > 0) {
        if (self.isSearchingUsers) {
            NSArray *userSearch = [[SSNetworkController sharedController] usersForSearchString:textField.text];
            if ([userSearch count] > 0) {
                [self.searches removeObjectAtIndex:0];
                [self.searches insertObject:textField.text atIndex:0];
                
                [self createUsersFromArray:userSearch];
                
                self.detailViewController.detailItem = self.usersArray[0];
                [self.detailViewController configureView];
                [self.theCollectionView reloadData];
                [textField resignFirstResponder];
                return YES;
            }
        } else {
            NSArray *repoSearch = [[SSNetworkController sharedController] reposForSearchString:textField.text];
            if ([repoSearch count] > 0) {
                [self.searches removeObjectAtIndex:1];
                [self.searches insertObject:textField.text atIndex:1];
                
                [self createReposFromArray:repoSearch];
                
                self.detailViewController.detailItem = self.repos[0];
                [self.detailViewController configureView];
                [self.theCollectionView reloadData];
                [textField resignFirstResponder];
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - array population
-(void)createUsersFromArray:(NSArray*)searchArray
{
    [self.usersArray removeAllObjects];
    for (NSDictionary *userInfo in searchArray) {
        SSGitHubUser *user = [SSGitHubUser new];
        user.name = userInfo[@"login"];
        user.html_url = userInfo[@"html_url"];
        user.imageURLString = userInfo[@"avatar_url"];
        [self.usersArray addObject:user];
    }
}

-(void)createReposFromArray:(NSArray*)searchArray
{
    [self.repos removeAllObjects];
    for (NSDictionary *userInfo in searchArray) {
        SSGitHubRepo *user = [SSGitHubRepo new];
        user.title = userInfo[@"name"];
        user.html_url = userInfo[@"html_url"];
        user.name = userInfo[@"owner"][@"login"];
        user.imageURLString = userInfo[@"owner"][@"avatar_url"];
        [self.repos addObject:user];
    }
}

#pragma mark - text field controls
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [self growSearchField];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [self shrinkSearchField];
    }
}

-(void)touchesBeganOnTableView
{
    if ([self.searchField isFirstResponder]) {
        [self.searchField resignFirstResponder];
        self.searchField.textAlignment = NSTextAlignmentCenter;
        [self shrinkSearchField];
    }
}

#pragma mark - Search Bar Animations
-(void) growSearchField
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [(SSSplitViewController*)self.parentViewController.parentViewController showMenuFullScreen];
    }
    self.searchField.textAlignment = NSTextAlignmentLeft;
    [UIView animateWithDuration:.4f animations:^{
        self.searchField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
            CGFloat percentToChange = (CGRectGetWidth(self.view.frame)-40)/self.searchSwitch.frame.size.width;
            [self getRectForSearchSwitchWithPercent:percentToChange];
            self.searchField.frame = CGRectMake(20, 20, CGRectGetWidth(self.view.frame)-40, CGRectGetHeight(self.searchField.frame));
        }
    }];
}

-(void) shrinkSearchField
{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [(SSSplitViewController*)self.parentViewController.parentViewController showMenuSplit];
    }
    self.searchField.textAlignment = NSTextAlignmentCenter;
    
    self.searchField.backgroundColor = [UIColor lightGrayColor];
    CGFloat newXorigin = (.8*CGRectGetWidth(self.view.frame)-40);
    
    CGFloat percentToChange;
    if (newXorigin > (MAX_OPEN_SPACE-40)) {
        percentToChange = (MAX_OPEN_SPACE-40)/self.searchSwitch.frame.size.width;
    } else {
        percentToChange = newXorigin/self.searchSwitch.frame.size.width;
    }
    
    CGRect newSearchFieldFrame = self.searchField.frame;
    newSearchFieldFrame.origin.x = 20.f;
    newSearchFieldFrame.origin.y = 20.f;
    newSearchFieldFrame.size.width  = percentToChange*CGRectGetWidth(self.searchField.frame);
    [UIView animateWithDuration:.4f animations:^{
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {

            [self getRectForSearchSwitchWithPercent:percentToChange];
            self.searchField.frame = newSearchFieldFrame;
        }
    }];
}

-(void) getRectForSearchSwitchWithPercent:(CGFloat) percent{
    self.searchSwitch.frame = CGRectMake(20, self.searchSwitch.frame.origin.y, percent*self.searchSwitch.frame.size.width, CGRectGetHeight(self.searchField.frame));;
    for (id subView in [self.searchSwitch subviews]) {
        UIView *thisSubView = (UIView*)subView;
        thisSubView.frame = CGRectMake(thisSubView.frame.origin.x, thisSubView.frame.origin.y, percent*thisSubView.frame.size.width, thisSubView.frame.size.height);
    }
}

#pragma mark - UICollectionView DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.isSearchingUsers) {
        return [self.usersArray count];
    } else {
        return [self.repos count];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchingUsers){
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            switch (indexPath.row) {
                case 0: //one large
                    return CGSizeMake(210, 210);
                    break;

                default:
                    return CGSizeMake(135, 135);
                    break;
            }
        } else {
            switch (indexPath.row) {
                case 0: //small
                    return CGSizeMake(200, 200);
                    break;
                    
                default:
                    return CGSizeMake(115, 115);
                    break;
            }
        }
    } else {
        //uitaleivew lookalike
        return CGSizeMake(255.f,60.f);
    }
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.isSearchingUsers) {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    } else {
        return UIEdgeInsetsMake(5, 0, 5, 0);
    }
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearchingUsers) {
        SSUserCollectionAvatarCell *cell = (SSUserCollectionAvatarCell*)[self.theCollectionView dequeueReusableCellWithReuseIdentifier:@"AvatarCell" forIndexPath:indexPath];
        SSGitHubUser *user = self.usersArray[indexPath.row];
        if (user.userImage) {
            cell.userImageView.image = user.userImage;
        } else if (user.imageURLString) {
            [self loadUserAvatarAtIndex:indexPath];
        }
        [cell configureCell];
        [cell.name setText:[user name]];
        return cell;
    } else {
        SSRepoCollectionCell *cell = (SSRepoCollectionCell*)[self.theCollectionView dequeueReusableCellWithReuseIdentifier:@"RepoCell" forIndexPath:indexPath];
        SSGitHubRepo *user = self.repos[indexPath.row];
        if (user.userImage) {
            cell.userImageView.image = user.userImage;
        } else if (user.imageURLString) {
            [self loadUserAvatarAtIndex:indexPath];
        }
        [cell configureCell];
        [cell.title setText:[user title]];
        [cell.title sizeThatFits:cell.title.frame.size];
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if (self.isSearchingUsers) {
            SSGitHubUser *object = self.usersArray[indexPath.row];
            self.detailViewController.detailItem = object;
        } else {
            SSGitHubRepo *object = self.repos[indexPath.row];
            self.detailViewController.detailItem = object;
        }
    } else {
        if (self.isSearchingUsers) {
            SSGitHubUser *object = self.usersArray[indexPath.row];
            self.detailViewController.detailItem = object;
        } else {
            SSGitHubRepo *object = self.repos[indexPath.row];
            self.detailViewController.detailItem = object;
        }
        [self.detailViewController configureView];
        [(SSSplitViewController*)self.parentViewController.parentViewController hideMenu];
    }
}


#pragma mark - NSOperationQueue image load
-(void)loadUserAvatarAtIndex:(NSIndexPath*) indexPath {
    [self.downloadImagesQueue addOperationWithBlock:^{
        if (self.isSearchingUsers) {
            SSGitHubUser *user = [self.usersArray objectAtIndex:indexPath.row];
            [user downloadUserAvatar];
        } else {
            SSGitHubRepo *repo = [self.repos objectAtIndex:indexPath.row];
            [repo downloadUserAvatar];
        }
        if ([self.theCollectionView.visibleCells containsObject:[self.theCollectionView cellForItemAtIndexPath:indexPath]]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.theCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
        }
    }];
}
@end
