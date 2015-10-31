//
//  FirstSettingsViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <MSRangeSlider/MSRangeSlider.h>
#import "NSString+StringWithCapitalizedFirstCharOnly.h"
#import "ABMultiValuePickerController.h"

#import "Pinder.h"
#import "FirstSettingsViewController.h"

@interface FirstSettingsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *agesRangeLabel;
@property (nonatomic, weak) IBOutlet MSRangeSlider *rangeSlider;

@property (nonatomic, strong) Filter *filter;

@end

@implementation FirstSettingsViewController

- (Filter *)filter
{
    if (_filter == nil) {
        _filter = [Filter MR_findFirst];
        if (_filter == nil)
            _filter = [Filter MR_createEntity];
    }
    return _filter;
}

- (void)setRangeSlider:(MSRangeSlider *)rangeSlider
{
    _rangeSlider = rangeSlider;
    [_rangeSlider addTarget:self action:@selector(rangeSliderChanged:) forControlEvents:(UIControlEventValueChanged)];
}

- (void)rangeSliderChanged:(MSRangeSlider *)rangeSlider
{
    self.agesRangeLabel.text = [NSString stringWithFormat:@"%@-%@", @((NSInteger)rangeSlider.fromValue+13), @((NSInteger)rangeSlider.toValue+13)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

#pragma mark - Table View

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
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = ^{
            if (self.filter.sex_m.boolValue && self.filter.sex_w.boolValue)
                return @"Парни и девушки";
            if (self.filter.sex_m.boolValue)
                return @"Тольно парни";
            if (self.filter.sex_w.boolValue)
                return @"Только девушки";
            return @"Не важно";
        }();
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ABMultiValuePickerController *controller = [[ABMultiValuePickerController alloc] init];
    controller.view.tintColor = self.view.tintColor;
    
    if (indexPath.row == 1)
    {
        controller.title = @"Меня интересуют";
        controller.items = @[@"парни",@"девушки"];
        if (self.filter.sex_m.boolValue)
            [controller.selectedItems addObject:controller.items[0]];
        if (self.filter.sex_w.boolValue)
            [controller.selectedItems addObject:controller.items[1]];
        controller.allowMultipleSelection = YES;
        
        __weak typeof(controller) weakController = controller;
        controller.completion = ^(){
            self.filter.sex_m = @([weakController.selectedItems containsObject:weakController.items[0]]);
            self.filter.sex_w = @([weakController.selectedItems containsObject:weakController.items[1]]);
            [self setupCell:cell forIndexPath:indexPath];
        };
        [self presentViewController:controller animated:YES completion:nil];
    }
}

@end
