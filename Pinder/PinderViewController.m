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

@interface PinderViewController () <ABPinderViewDataSource,NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) IBOutlet ABPinderView *pinderView;

@property (nonatomic, strong) NSMutableArray<User *> *users;

@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation PinderViewController

- (NSFetchedResultsController *)frc
{
    if (_frc == nil) {
        _frc = [User MR_fetchAllSortedBy:@"sort_id" ascending:YES withPredicate:nil groupBy:nil delegate:self];
        self.users = [self.frc.fetchedObjects mutableCopy];
    }
    return _frc;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    self.users = [self.frc.fetchedObjects mutableCopy];
    [self.pinderView reloadData];
}

- (NSMutableArray *)users
{
    return [[User MR_findAllSortedBy:@"sort_id" ascending:YES] mutableCopy];
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

- (void)pinderView:(ABPinderView *)pinderView movedToLeft:(NSInteger)index
{
    if (index >= self.users.count)
        return;

    [[PinderServer sharedServer] dislike:self.users[index].identifier.integerValue filter:[Filter sharedFilter].filter_id.integerValue completion:^(NSArray *arrUsers) {
        if (arrUsers == nil)
            return;
        
        NSInteger nextSortId = [User nextSortId];
        NSArray<User *> *users = [FEMDeserializer collectionFromRepresentation:arrUsers mapping:[User mapping] context:[NSManagedObjectContext MR_defaultContext]];
        for (NSInteger i = 0; i < users.count; i++)
            users[i].sort_id = @(nextSortId+i);
    }];
    [self.users[index] MR_deleteEntity];
    self.pinderView.globalIndex--;
}

- (void)pinderView:(ABPinderView *)pinderView movedToRight:(NSInteger)index
{
    if (index >= self.users.count)
        return;
    
    [[PinderServer sharedServer] like:self.users[index].identifier.integerValue filter:[Filter sharedFilter].filter_id.integerValue completion:^(NSArray *arrUsers) {
        if (arrUsers == nil)
            return;
        
        NSInteger nextSortId = [User nextSortId];
        NSArray<User *> *users = [FEMDeserializer collectionFromRepresentation:arrUsers mapping:[User mapping] context:[NSManagedObjectContext MR_defaultContext]];
        for (NSInteger i = 0; i < users.count; i++)
            users[i].sort_id = @(nextSortId+i);
    }];
    [self.users[index] MR_deleteEntity];
    self.pinderView.globalIndex--;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"vk://vk.com/id%@", self.users[index].user_id]]];
}

- (NSInteger)numberOfItemsInPinderView:(ABPinderView *)pinderView
{
    return self.users.count;
}

- (void)pinderView:(ABPinderView *)pinderView willDisplayItem:(PinderCell *)cell atIndex:(NSInteger)index
{
    if (index < self.users.count)
        cell.user = self.users[index];
    
    cell.blurView.hidden = YES;
    cell.blurView.alpha = 0;
    cell.likeSplash.alpha = 0;
    cell.skipSplash.alpha = 0;
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
    if (distance > 0) {
        cell.skipSplash.alpha = 0;
        cell.likeSplash.alpha = ABS(distance)/80;
        CGFloat scale = 0.8 + MIN(0.2,ABS(distance)/200);
        cell.likeSplash.transform = CGAffineTransformMakeScale(scale,scale);
    }
    else {
        cell.likeSplash.alpha = 0;
        cell.skipSplash.alpha = ABS(distance)/80;
        CGFloat scale = 0.8 + MIN(0.2,ABS(distance)/200);
        cell.skipSplash.transform = CGAffineTransformMakeScale(scale,scale);
    }
}

- (void)pinderView:(ABPinderView *)pinderView animateBackCell:(PinderCell *)cell atIndex:(NSInteger)index
{
    cell.blurView.hidden = YES;
    cell.likeSplash.alpha = 0;
    cell.skipSplash.alpha = 0;
}

- (void)pinderView:(ABPinderView *)pinderView animateLeftCell:(PinderCell *)cell atIndex:(NSInteger)index
{
    [self prepareBlurInCell:cell];
    cell.blurView.alpha = 1.0;
    cell.likeSplash.alpha = 0.0;
    cell.likeSplash.transform = CGAffineTransformIdentity;
    cell.skipSplash.alpha = 1.0;
    cell.skipSplash.transform = CGAffineTransformIdentity;
}

- (void)pinderView:(ABPinderView *)pinderView animateRightCell:(PinderCell *)cell atIndex:(NSInteger)index
{
    [self prepareBlurInCell:cell];
    cell.blurView.alpha = 1.0;
    cell.likeSplash.alpha = 1.0;
    cell.likeSplash.transform = CGAffineTransformIdentity;
    cell.skipSplash.alpha = 0.0;
    cell.skipSplash.transform = CGAffineTransformIdentity;
}

- (void)cardTapped:(id)sender
{
}

#pragma mark - Navigation

- (IBAction)back:(UIStoryboardSegue *)segue
{
}

@end
