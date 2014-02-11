//
//  SSMasterViewController.h
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSFrontViewController.h"
@class SSSplitViewController;

@interface SSBackViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic) SSFrontViewController *detailViewController;

@property (strong,nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *userFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *repoFetchedResultsController;

@end
