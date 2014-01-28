//
//  SSMasterViewController.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSMasterViewController.h"
#import "SSNetworkController.h"
#import "SSDetailViewController.h"
#import "SSMenuListTableView.h"
#import "SSMenuViewController.h"

@interface SSMasterViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic) NSArray *repos;
@property (nonatomic) IBOutlet SSMenuListTableView *theTableView;
@property (nonatomic) IBOutlet UITextField *searchField;

@end

@implementation SSMasterViewController

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
    
    self.repos = [[NSArray alloc] init];
    self.searchField.delegate = self;
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController = (SSDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
        
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchesBeganOnTableView) name:@"TouchOccurredOnTableView" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text length] > 0) {
        NSArray *repoSearch = [[SSNetworkController sharedController] reposForSearchString:textField.text];
        if ([repoSearch count] > 0) {
            self.repos = repoSearch;
            [self.theTableView reloadData];
            self.detailViewController.detailItem = self.repos[0];
            [self.detailViewController configureView];
            [textField resignFirstResponder];
        }
        return YES;
    }
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.textAlignment = NSTextAlignmentLeft;
    [UIView animateWithDuration:.4f animations:^{
        textField.backgroundColor = [UIColor groupTableViewBackgroundColor];
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
            textField.frame = CGRectMake(20, 20, CGRectGetWidth(self.view.frame)-40, CGRectGetHeight(textField.frame));
            [self.theSplitController shiftDetailToHideFull];
        }
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self shrinkSearchField];
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [self.theSplitController shiftDetailToPartialHide];
    } else {
    }
}

#pragma mark UIResponder to touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchOccurredOnTableView" object:nil];
}

-(void)touchesBeganOnTableView {
    if ([self.searchField isFirstResponder]) {
        [self.searchField resignFirstResponder];
    }
}

-(void) shrinkSearchField {
    self.searchField.textAlignment = NSTextAlignmentCenter;
    [UIView animateWithDuration:.4f animations:^{
        self.searchField.backgroundColor = [UIColor lightGrayColor];
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
            self.searchField.frame = CGRectMake(20, 20, .8*CGRectGetWidth(self.view.frame)-40, CGRectGetHeight(self.searchField.frame));
        }
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *object = self.repos[indexPath.row];
    cell.textLabel.text = [object objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDate *object = self.repos[indexPath.row];
        self.detailViewController.detailItem = object;
    } else {
        NSDate *object = self.repos[indexPath.row];
        self.detailViewController.detailItem = object;
        [self.detailViewController configureView];
        [self.theSplitController shiftDetailToShowFull];
    }
}
@end
