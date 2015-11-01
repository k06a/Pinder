//
//  ABPinderView.h
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright (c) 2015 Happy Santa. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "ABPinderView.h"

@interface ABPinderView ()

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) UITableViewCell *reusableView;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) NSMutableArray *exceptViews;

@property (nonatomic, assign) NSInteger globalIndex;

@end

@implementation ABPinderView

- (NSMutableArray *)exceptViews
{
    if (_exceptViews == nil)
        _exceptViews = [NSMutableArray array];
    return _exceptViews;
}

- (CGFloat)offset
{
    if (_offset == 0.0)
        _offset = 10;
    return _offset;
}

- (NSMutableArray *)views
{
    if (_views == nil)
        _views = [NSMutableArray array];
    return _views;
}

- (NSInteger)currentIndex
{
    return self.globalIndex - self.count;
}

- (UIView *)topView
{
    UITableViewCell *cell = self.views.firstObject;
    return cell.contentView.subviews.firstObject;
}

- (UIView *)clonedTopView
{
    return [self cloneSelfView:NO];
}

- (UITableViewCell *)reusableView
{
    if (_reusableView == nil) {
        _reusableView = [self cloneSelfView:YES];
        [_reusableView removeFromSuperview];
    }
    return _reusableView;
}

- (UITableViewCell *)cloneSelfView:(BOOL)insert
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"cell"];
    cell.clipsToBounds = NO;
    cell.contentView.clipsToBounds = NO;
    cell.contentView.frame = self.bounds;
    cell.frame = self.bounds;
    if (insert)
        [self insertSubview:cell atIndex:0];
    return cell;
}

- (void)setCount:(NSInteger)count
{
    for (NSInteger i = _count; i < MIN(count,[self.tinderDelegate numberOfItemsInPinderView:self]); i++)
    {
        UIView *view = [self cloneSelfView:YES];
        if ([self.tinderDelegate respondsToSelector:@selector(pinderView:willDisplayItem:atIndex:)])
            [self.tinderDelegate pinderView:self willDisplayItem:(id)view atIndex:i];
        [self.views addObject:view];
    }
    for (NSInteger i = _count; i >= count; i--) {
        UIView *view = self.views.lastObject;
        [view removeFromSuperview];
        [self.views removeLastObject];
    }
    
    _count = count;
    self.globalIndex = count;
}

- (void)layoutIfNeeded
{
    //[super layoutIfNeeded];
    [self letsLayout];
}

- (void)layoutSubviews
{
    //[super layoutSubviews];
    [self letsLayout];
}

- (CGAffineTransform)originTransformForViewAtIndex:(NSInteger)index
{
    return [self originTransformForViewAtIndex:index progress:0];
}

- (CGAffineTransform)originTransformForViewAtIndex:(NSInteger)index progress:(CGFloat)progress
{
    CGAffineTransform tr = CGAffineTransformMakeScale((self.bounds.size.width - MAX(0,index-progress)*2*self.offset)/self.bounds.size.width, (self.bounds.size.height - MAX(0,index-progress)*2*self.offset)/self.bounds.size.height);
    return CGAffineTransformTranslate(tr, 0, MAX(0,index-progress)*2*self.offset);
}

- (void)letsLayout
{
    for (NSInteger i = 0; i < self.views.count; i++) {
        UIView *view = self.views[i];
        if (![self.exceptViews containsObject:view]) {
            view.transform = [self originTransformForViewAtIndex:i progress:self.progress];
            view.alpha = 1.0*(self.views.count-i)/self.views.count + self.progress/self.views.count;
        }
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.pan == nil) {
        for (UIView *view in self.subviews)
            if (![view isKindOfClass:[UITableViewCell class]])
                [view removeFromSuperview];
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.clipsToBounds = NO;
        self.scrollEnabled = NO;
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:self.pan];
    }
}

- (CGAffineTransform)transfromForOffset:(CGPoint)offset
{
    CGAffineTransform tr = CGAffineTransformMakeTranslation(offset.x, offset.y);//-ABS(sin(offset.x/100)*30));
    return CGAffineTransformRotate(tr, offset.x/500);
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint offset = [self.pan translationInView:self];
    CGFloat distance = sqrt(offset.x*offset.x + offset.y*offset.y);
    self.progress = MIN(1,distance/80);
    
    if (self.pan.state == UIGestureRecognizerStateChanged)
    {
        self.topView.transform = [self transfromForOffset:offset];
        if ([self.tinderDelegate respondsToSelector:@selector(pinderView:updateCell:atIndex:forDistance:)])
            [self.tinderDelegate pinderView:self updateCell:self.views.firstObject atIndex:self.globalIndex-self.count+1 forDistance:offset.x];
        [self layoutIfNeeded];
        if (self.reusableView.superview == nil) {
            if ([self.tinderDelegate respondsToSelector:@selector(pinderView:willDisplayItem:atIndex:)])
                [self.tinderDelegate pinderView:self willDisplayItem:self.reusableView atIndex:self.globalIndex];
            [self insertSubview:self.reusableView atIndex:0];
            self.reusableView.alpha = 0.1;
            self.reusableView.transform = [self originTransformForViewAtIndex:self.views.count-1];
        }
    }
    
    if (self.pan.state == UIGestureRecognizerStateCancelled ||
        self.pan.state == UIGestureRecognizerStateFailed ||
        (self.pan.state == UIGestureRecognizerStateEnded &&
         (distance < 80 || ABS(offset.x) < 10)))
    {
        [UIView animateWithDuration:0.35 delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0 options:(UIViewAnimationOptionCurveLinear) animations:^{
            self.topView.transform = CGAffineTransformIdentity;
            if ([self.tinderDelegate respondsToSelector:@selector(pinderView:animateBackCell:atIndex:)])
                [self.tinderDelegate pinderView:self animateBackCell:self.views.firstObject atIndex:self.globalIndex-self.count+1];
        } completion:nil];
        
        [UIView animateWithDuration:0.2 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            self.progress = 0.0;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.reusableView removeFromSuperview];
        }];
    }
    
    if (self.pan.state == UIGestureRecognizerStateEnded &&
        distance >= 80 && ABS(offset.x) >= 10)
    {
        [self animateSwipeTo:offset.x];
    }
}

- (void)animateSwipeLeft
{
    self.pan.enabled = NO;
    self.pan.enabled = YES;
    [self animateSwipeTo:-1];
}

- (void)animateSwipeRight
{
    self.pan.enabled = NO;
    self.pan.enabled = YES;
    [self animateSwipeTo:1];
}

- (void)animateSwipeTo:(CGFloat)offset
{
    UITableViewCell *cell = self.views.firstObject;
    UIView *topView = self.topView;
    [self.exceptViews addObject:topView];
    [self.views removeObjectAtIndex:0];
    [self.views addObject:self.reusableView];
    
    if (self.reusableView.superview == nil) {
        if ([self.tinderDelegate respondsToSelector:@selector(pinderView:willDisplayItem:atIndex:)])
            [self.tinderDelegate pinderView:self willDisplayItem:self.reusableView atIndex:self.globalIndex];
        [self insertSubview:self.reusableView atIndex:0];
        self.reusableView.transform = [self originTransformForViewAtIndex:self.views.count-1];
    }
    
    self.reusableView = nil;
    [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{
        CGFloat sign = offset/ABS(offset);
        topView.transform = [self transfromForOffset:CGPointMake(sign*[UIScreen mainScreen].bounds.size.width*1.5,100)];
        if (sign < 0) {
            if ([self.tinderDelegate respondsToSelector:@selector(pinderView:animateLeftCell:atIndex:)])
                [self.tinderDelegate pinderView:self animateLeftCell:cell atIndex:self.globalIndex-self.count+1];
        } else {
            if ([self.tinderDelegate respondsToSelector:@selector(pinderView:animateRightCell:atIndex:)])
                [self.tinderDelegate pinderView:self animateRightCell:cell atIndex:self.globalIndex-self.count+1];
        }
        self.progress = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (![self.views containsObject:cell])
            [cell removeFromSuperview];
        if (_reusableView == nil)
            self.reusableView = cell;
        topView.transform = CGAffineTransformIdentity;
        [self.exceptViews removeObject:topView];
        if ([self.tinderDelegate respondsToSelector:@selector(pinderView:didHideTopItem:)])
            [self.tinderDelegate pinderView:self didHideTopItem:self.reusableView];
    }];
    
    self.globalIndex++;
}

- (IBAction)animateSwipeLeft:(id)sender
{
    self.pan.enabled = NO;
    self.pan.enabled = YES;
    [self animateSwipeLeft];
}

- (IBAction)animateSwipeRight:(id)sender
{
    self.pan.enabled = NO;
    self.pan.enabled = YES;
    [self animateSwipeRight];
}

- (void)animateSwipeBackFromLeft
{
    [self animateSwipeBackFrom:-1];
}

- (void)animateSwipeBackFromRight
{
    [self animateSwipeBackFrom:1];
}

- (void)animateSwipeBackFrom:(CGFloat)offset
{
    if (self.globalIndex-self.count-1 < 0)
        return;
    CGFloat sign = offset/ABS(offset);
    
    UITableViewCell *prevTopCell = self.views.firstObject;
    UITableViewCell *cell = self.reusableView;
    self.reusableView = nil;
    UIView *topView = cell.contentView.subviews.firstObject;
    [self.exceptViews addObject:topView];
    self.reusableView = self.views.lastObject;
    [self.reusableView removeFromSuperview];
    [self.views removeLastObject];
    [self.views insertObject:cell atIndex:0];
    
    if ([self.tinderDelegate respondsToSelector:@selector(pinderView:willDisplayItem:atIndex:)])
        [self.tinderDelegate pinderView:self willDisplayItem:cell atIndex:self.globalIndex-self.count-1];
    [self addSubview:cell];
    cell.transform = [self originTransformForViewAtIndex:0];
    topView.transform = [self transfromForOffset:CGPointMake(sign*[UIScreen mainScreen].bounds.size.width*1.5,100)];
    [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveLinear) animations:^{
        topView.transform = CGAffineTransformIdentity;
        self.progress = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (![self.views containsObject:cell])
            [cell removeFromSuperview];
        [self.exceptViews removeObject:topView];
        if ([self.tinderDelegate respondsToSelector:@selector(pinderView:didHideTopItem:)])
            [self.tinderDelegate pinderView:self didHideTopItem:prevTopCell];
    }];
    
    self.globalIndex--;
}

- (void)reloadData
{
    self.count = self.count;
}

@end
