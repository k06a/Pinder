//
//  FirstSettingsViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <MSRangeSlider/MSRangeSlider.h>

#import "FirstSettingsViewController.h"

@interface FirstSettingsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *agesRangeLabel;
@property (nonatomic, weak) IBOutlet MSRangeSlider *rangeSlider;

@end

@implementation FirstSettingsViewController

- (NSDictionary *)items
{
    if (super.items == nil) {
        super.items = @{@"sex":@{@"items":@[@"парни",@"девушки"],
                                 @"keys":@[@"sex_m",@"sex_w"],
                                 @"title":@"Меня интересуют",
                                 @"multiple":@YES,
                                 @"none":@NO,
                                 @"only":@YES},
                        @"ctr":@{@"items":[self.countries valueForKey:@"title"],
                                 @"key":@"country_index",
                                 @"title":@"Проживают в стране",
                                 @"multiple":@NO,
                                 @"none":@NO,
                                 @"only":@NO},
                        @"cty":@{@"items":[self.cities valueForKey:@"title"],
                                 @"key":@"city_index",
                                 @"title":@"Проживают в стране",
                                 @"multiple":@NO,
                                 @"none":@NO,
                                 @"only":@NO},
                        };
    }
    return super.items;
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
        cell.detailTextLabel.text = [self descriptionForItem:self.items[@"sex"]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *item = ^id{
        if (indexPath.row == 1)
            return self.items[@"sex"];
        if (indexPath.row == 2)
            return self.items[@"ctr"];
        return nil;
    }();
    
    if (item)
    {
        [self presentChoiseControllerForItem:item completion:^{
            [self setupCell:cell forIndexPath:indexPath];
        }];
    }
}

@end
