//
//  ValuePickerViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "ABMultiValuePickerController.h"

@interface ABMultiValuePickerController ()

@end

@implementation ABMultiValuePickerController

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self updateAllControllers];
}

- (void)setItems:(NSArray<NSString *> *)items
{
    _items = items;
    [self updateAllControllers];
}

- (void)setAllowMultipleSelection:(BOOL)allowMultipleSelection
{
    _allowMultipleSelection = allowMultipleSelection;
    [self updateAllControllers];
}

- (void)setAllowNoneSelection:(BOOL)allowNoneSelection
{
    _allowNoneSelection = allowNoneSelection;
    [self updateAllControllers];
}

- (void)setCompletion:(void (^)())completion
{
    _completion = [completion copy];
    [self updateAllControllers];
}

- (NSString *)selectedItem
{
    return (id)[(id)self.viewControllers.lastObject selectedItem];
}

- (NSMutableArray<NSString *> *)selectedItems
{
    return [(id)self.viewControllers.lastObject selectedItems];
}

- (void)updateAllControllers
{
    for (UIViewController *controller in self.viewControllers)
        [self updateController:controller];
}

- (void)updateController:(UIViewController *)controller
{
    controller.title = self.title;
    if ([controller respondsToSelector:@selector(setItems:)])
        [(id)controller setItems:(id)self.items];
    if ([controller respondsToSelector:@selector(setAllowMultipleSelection:)])
        [(id)controller setAllowMultipleSelection:self.allowMultipleSelection];
    if ([controller respondsToSelector:@selector(setCompletion:)])
        [(id)controller setCompletion:self.completion];
}

- (instancetype)init
{
    self = [[UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:nil] instantiateInitialViewController];
    [self updateAllControllers];
    return self;
}

@end
