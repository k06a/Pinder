//
//  ValuePickerViewController.m
//  Pinder
//
//  Created by Антон Буков on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "ValuePickerViewController.h"

@interface ValuePickerViewController ()

@end

@implementation ValuePickerViewController

- (NSMutableArray<NSString *> *)selectedItems
{
    if (_selectedItems == nil)
        _selectedItems = [NSMutableArray array];
    return _selectedItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedItems indexOfObject:self.items[indexPath.row]] == NSNotFound) {
        [self.selectedItems addObject:self.items[indexPath.row]];
        if (!self.allowMultipleSelection)
            [self.selectedItems removeObjectAtIndex:0];
    }
    
    [self.tableView reloadData];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
