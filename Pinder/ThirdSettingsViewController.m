//
//  ThirdSettingsViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "ThirdSettingsViewController.h"

@interface ThirdSettingsViewController ()

@end

@implementation ThirdSettingsViewController

- (NSDictionary *)items
{
    if (super.items == nil) {
        super.items = @{@"zod":@{@"items":@[@"Овен",@"Телец",@"Близнецы",
                                            @"Рак",@"Лев",@"Дева",@"Весы",
                                            @"Скорпион",@"Стрелец",@"Козерог",
                                            @"Водолей",@"Рыба"],
                                 @"keys":@[@"z1",@"z2",@"z3",@"z4",
                                           @"z5",@"z6",@"z7",@"z8",
                                           @"z9",@"z10",@"z11",@"z12"],
                                 @"title":@"Знак зодиака",
                                 @"multiple":@YES,
                                 @"none":@YES,
                                 @"only":@NO},
                        };
    }
    return super.items;
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
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.detailTextLabel.text = [self descriptionForItem:self.items[@"zod"]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *item = ^id{
        if (indexPath.section == 1 && indexPath.row == 1)
            return self.items[@"zod"];
        return nil;
    }();
    
    if (item)
    {
        [self presentChoiseControllerForItem:item completion:^{
            [self setupCell:cell forIndexPath:indexPath];
            self.items = nil;
        }];
    }
}

@end
