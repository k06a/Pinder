//
//  ABPinderView.h
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright (c) 2015 Happy Santa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABPinderView;

@protocol ABPinderViewDataSource <NSObject>
@optional
- (NSInteger)numberOfItemsInPinderView:(ABPinderView *)pinderView;
- (void)pinderView:(ABPinderView *)pinderView willDisplayItem:(UITableViewCell *)cell atIndex:(NSInteger)index;
- (void)pinderView:(ABPinderView *)pinderView didHideTopItem:(UITableViewCell *)cell;

- (void)pinderView:(ABPinderView *)pinderView movedToLeft:(NSInteger)index;
- (void)pinderView:(ABPinderView *)pinderView movedToRight:(NSInteger)index;

- (void)pinderView:(ABPinderView *)pinderView updateCell:(UITableViewCell *)cell atIndex:(NSInteger)index forDistance:(CGFloat)distance;
- (void)pinderView:(ABPinderView *)pinderView animateBackCell:(UITableViewCell *)cell atIndex:(NSInteger)index;
- (void)pinderView:(ABPinderView *)pinderView animateLeftCell:(UITableViewCell *)cell atIndex:(NSInteger)index;
- (void)pinderView:(ABPinderView *)pinderView animateRightCell:(UITableViewCell *)cell atIndex:(NSInteger)index;

@end

//

IB_DESIGNABLE
@interface ABPinderView : UITableView

@property (nonatomic, weak) IBOutlet id<ABPinderViewDataSource> tinderDelegate;
@property (nonatomic, assign) IBInspectable NSInteger count;
@property (nonatomic, assign) IBInspectable CGFloat offset;

@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, readonly) UIView *topView;
@property (nonatomic, readonly) UIView *clonedTopView;

- (void)animateSwipeLeft;
- (void)animateSwipeRight;

- (void)animateSwipeBackFromLeft;
- (void)animateSwipeBackFromRight;

- (void)reloadData;

@end
