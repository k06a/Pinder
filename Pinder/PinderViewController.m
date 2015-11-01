//
//  ViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "PinderServer.h"
#import "ABPinderView.h"
#import "PinderCell.h"
#import "Pinder.h"
#import "PinderViewController.h"

@interface PinderViewController () <ABPinderViewDataSource>

@property (nonatomic, weak) IBOutlet ABPinderView *pinderView;

@property (nonatomic, strong) NSMutableArray<User *> *users;

@end

@implementation PinderViewController

- (NSMutableArray *)users
{
    if (_users == nil)
        _users = [[User MR_findAllSortedBy:@"sort_id" ascending:YES] mutableCopy];
    return _users;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.pinderView.count = 3;
        self.pinderView.offset = 12;
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([PinderServer sharedServer].user_id == nil &&
        [PinderServer sharedServer].server_token == nil)
    {
        [self performSegueWithIdentifier:@"segue_login" sender:self];
    }
    
    [self.pinderView reloadData];
}

#pragma mark - Pinder View

- (NSInteger)numberOfItemsInPinderView:(ABPinderView *)pinderView
{
    return self.users.count;
}

- (void)pinderView:(ABPinderView *)pinderView willDisplayItem:(PinderCell *)cell atIndex:(NSInteger)index
{
    cell.user = self.users[index];
    cell.blurView.hidden = YES;
    cell.likeSplash.alpha = 0;
    cell.likeSplash.transform = CGAffineTransformMakeScale(0.5,0.5);
}

- (void)pinderView:(ABPinderView *)pinderView didHideTopItem:(PinderCell *)cell
{
    
}

- (void)prepareBlurInCell:(PinderCell *)cell
{
    if (cell.blurView.hidden) {
        cell.blurView.hidden = NO;
        [cell.blurView blurOnceIfPossible];
    }
}

- (void)pinderView:(ABPinderView *)pinderView updateCell:(PinderCell *)cell atIndex:(NSInteger)index forDistance:(CGFloat)distance
{
    [self prepareBlurInCell:cell];
    cell.blurView.alpha = MAX(0,MIN(1,ABS(distance)/100));
    if (distance < 0) {
        cell.likeSplash.alpha = ABS(distance)/80;
        CGFloat scale = 0.5 + MIN(0.5,ABS(distance)/200);
        cell.likeSplash.transform = CGAffineTransformMakeScale(scale,scale);
    }
    else
        cell.likeSplash.alpha = 0;
}

- (void)pinderView:(ABPinderView *)pinderView animateBackCell:(PinderCell *)cell atIndex:(NSInteger)index
{
    cell.blurView.hidden = YES;
    cell.likeSplash.alpha = 0;
}

- (void)pinderView:(ABPinderView *)pinderView animateLeftCell:(PinderCell *)cell atIndex:(NSInteger)index
{
    [self prepareBlurInCell:cell];
    cell.blurView.alpha = 1.0;
    cell.likeSplash.alpha = 1.0;
    cell.likeSplash.transform = CGAffineTransformIdentity;
}

- (void)pinderView:(ABPinderView *)pinderView animateRightCell:(PinderCell *)cell atIndex:(NSInteger)index
{
    [self prepareBlurInCell:cell];
    cell.blurView.alpha = 1.0;
}

- (void)cardTapped:(id)sender
{
}

#pragma mark - Navigation

- (IBAction)back:(UIStoryboardSegue *)segue
{
}

@end
