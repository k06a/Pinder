//
//  ABMultiValuePickerTableController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "ABMultiValuePickerTableController.h"

@interface ABMultiValuePickerTableController ()

@end

@implementation ABMultiValuePickerTableController

- (NSString *)selectedItem
{
    return self.selectedItems.firstObject;
}

- (NSMutableArray<NSString *> *)selectedItems
{
    if (_selectedItems == nil)
        _selectedItems = [NSMutableArray array];
    return _selectedItems;
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setupCell:cell forIndexPath:indexPath];
}

- (void)setupCellAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell)
        [self setupCell:cell forIndexPath:indexPath];
}

- (void)setupCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    cell.tintColor = [UIColor grayColor];
    cell.textLabel.text = [self.items[indexPath.row] capitalizedString];
    cell.accessoryType = [self.selectedItems containsObject:self.items[indexPath.row]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.selectedItems containsObject:self.items[indexPath.row]]) {
        [self.selectedItems addObject:self.items[indexPath.row]];
        [self setupCellAtIndexPath:indexPath];
        if (!self.allowMultipleSelection) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.items indexOfObject:self.selectedItem] inSection:0];
            [self.selectedItems removeObjectAtIndex:0];
            [self setupCellAtIndexPath:ip];
        }
    } else if (self.allowMultipleSelection) {
        if (self.allowNoneSelection || self.selectedItems.count > 1) {
            [self.selectedItems removeObject:self.items[indexPath.row]];
            [self setupCellAtIndexPath:indexPath];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!self.allowMultipleSelection)
        [self doneTapped:nil];
}

#pragma mark - Navigation

- (IBAction)cancelTapped:(id)sender
{
    self.wasCancelled = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneTapped:(id)sender
{
    self.wasCancelled = NO;
    if (self.completion)
        self.completion();
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
