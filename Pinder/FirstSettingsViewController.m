//
//  FirstSettingsViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <MSRangeSlider/MSRangeSlider.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "FirstSettingsViewController.h"

@interface FirstSettingsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *agesRangeLabel;
@property (nonatomic, weak) IBOutlet MSRangeSlider *rangeSlider;
@property (nonatomic, weak) IBOutlet UISwitch *onlineSwitch;

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
                        @"con":@{@"items":[self.countries valueForKey:@"title"],
                                 @"key":@"country_index",
                                 @"title":@"Проживают в стране",
                                 @"multiple":@NO,
                                 @"none":@YES,
                                 @"only":@NO},
                        @"cit":@{@"items":[self.cities valueForKey:@"title"],
                                 @"key":@"city_index",
                                 @"title":@"Проживают в городе",
                                 @"multiple":@NO,
                                 @"none":@YES,
                                 @"only":@NO},
                        @"uni":@{@"items":[self.universities valueForKey:@"title"],
                                 @"key":@"university_index",
                                 @"title":@"Учились в ВУЗе",
                                 @"multiple":@NO,
                                 @"none":@YES,
                                 @"only":@NO},
                        @"rel":@{@"items":@[@"Не важно",
                                            @"Не женат/Не замужем",
                                            @"Есть друг/Есть подруга",
                                            @"Помолвлен/Помолвлена",
                                            @"Женат/Замужем",
                                            @"Всё сложно",
                                            @"В активном поиске",
                                            @"Влюблён/Влюблена",
                                            ],
                                 @"key":@"relationships_index",
                                 @"title":@"Состоит в отношениях",
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
    self.filter.age_from = @((NSInteger)rangeSlider.fromValue+13);
    self.filter.age_to = @((NSInteger)rangeSlider.toValue+13);
    self.agesRangeLabel.text = [NSString stringWithFormat:@"%@-%@", self.filter.age_from, @((NSInteger)rangeSlider.toValue+13)];
}

- (IBAction)onlineSwithcChanged:(UISwitch *)onlineSwitch
{
    self.filter.online = @(onlineSwitch.on);
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
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = [self descriptionForItem:self.items[@"con"]];
    }
    if (indexPath.row == 3) {
        cell.detailTextLabel.text = [self descriptionForItem:self.items[@"cit"]];
    }
    if (indexPath.row == 4) {
        cell.detailTextLabel.text = [self descriptionForItem:self.items[@"uni"]];
    }
    if (indexPath.row == 5) {
        cell.detailTextLabel.text = [self descriptionForItem:self.items[@"rel"]];
    }
    if (indexPath.row == 6) {
        self.rangeSlider.fromValue = self.filter.age_from.integerValue-13;
        self.rangeSlider.toValue = self.filter.age_to.integerValue-13;
        [self rangeSliderChanged:self.rangeSlider];
    }
    if (indexPath.row == 7) {
        self.onlineSwitch.on = self.filter.online.boolValue;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 3 && self.filter.country_index.integerValue == -1)
        return [SVProgressHUD showErrorWithStatus:@"Сперва выберите страну"];
    if (indexPath.row == 4 && self.filter.city_index.integerValue == -1)
        return [SVProgressHUD showErrorWithStatus:@"Сперва выберите город"];
    
    NSDictionary *item = ^id{
        if (indexPath.row == 1)
            return self.items[@"sex"];
        if (indexPath.row == 2)
            return self.items[@"con"];
        if (indexPath.row == 3)
            return self.items[@"cit"];
        if (indexPath.row == 4)
            return self.items[@"uni"];
        if (indexPath.row == 5)
            return self.items[@"rel"];
        return nil;
    }();
    
    if (item)
    {
        [self presentChoiseControllerForItem:item completion:^{
            [self setupCell:cell forIndexPath:indexPath];
            if (indexPath.row == 2) {
                self.filter.city_index = @-1;
                self.filter.university_index = @-1;
            }
            if (indexPath.row == 3) {
                self.filter.university_index = @-1;
            }
            self.items = nil;
        }];
    }
}

@end
