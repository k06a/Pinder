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
- (NSInteger)numberOfItemsInPinderView:(ABPinderView *)tinderView;
- (void)tinderView:(ABPinderView *)tinderView willDisplayItem:(UITableViewCell *)cell atIndex:(NSInteger)index;
- (void)tinderView:(ABPinderView *)tinderView didHideTopItem:(UITableViewCell *)cell;

- (void)tinderView:(ABPinderView *)tinderView movedToLeft:(NSInteger)index;
- (void)tinderView:(ABPinderView *)tinderView movedToRight:(NSInteger)index;

- (void)tinderView:(ABPinderView *)tinderView updateCell:(UITableViewCell *)cell atIndex:(NSInteger)index forDistance:(CGFloat)distance;
- (void)tinderView:(ABPinderView *)tinderView animateBackCell:(UITableViewCell *)cell atIndex:(NSInteger)index;
- (void)tinderView:(ABPinderView *)tinderView animateLeftCell:(UITableViewCell *)cell atIndex:(NSInteger)index;
- (void)tinderView:(ABPinderView *)tinderView animateRightCell:(UITableViewCell *)cell atIndex:(NSInteger)index;

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

@end
