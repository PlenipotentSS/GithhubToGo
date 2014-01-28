//
//  SSMenuListTableView.m
//  Github To Go
//
//  Created by Stevenson on 1/27/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import "SSMenuListTableView.h"
@interface SSMenuListTableView()

@property (nonatomic) BOOL keyboardAppeared;

@end

@implementation SSMenuListTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

#pragma mark UIResponder to touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TouchOccurredOnTableView" object:nil];
    [super touchesBegan:touches withEvent:event];
}
@end
