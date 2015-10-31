//
//  AbstractSettingsViewController.m
//  Pinder
//
//  Created by Антон Буков on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "NSString+StringWithCapitalizedFirstCharOnly.h"
#import "ABMultiValuePickerController.h"

#import "PinderServer.h"
#import "AbstractSettingsViewController.h"

@interface AbstractSettingsViewController ()

@end

@implementation AbstractSettingsViewController

- (NSArray *)countries
{
    if (_countries == nil)
        _countries = [Country MR_findAllSortedBy:@"title" ascending:YES];
    return _countries;
}

- (NSArray *)cities
{
    return [City MR_findAllSortedBy:@"title" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"country_id = %@", self.countries[self.filter.country_index.integerValue]]];
}

- (Filter *)filter
{
    if (_filter == nil) {
        _filter = [Filter MR_findFirst];
        if (_filter == nil) {
            _filter = [Filter MR_createEntity];
            _filter.sex_m = @([[User me].sex integerValue] == SexWoman);
            _filter.sex_w = @([[User me].sex integerValue] == SexMan);
            //_filter.country_index = [[self.countries valueForKey:@"country_id"] indexOfObject:[User me].country.country_id];
        }
    }
    return _filter;
}

- (NSString *)descriptionForItem:(NSDictionary *)item
{
    NSMutableArray *texts = [NSMutableArray array];
    if (item[@"keys"]) {
        for (NSInteger i = 0; i < [item[@"keys"] count]; i++) {
            NSString *key = item[@"keys"][i];
            if ([[self.filter valueForKey:key] boolValue]) {
                [texts addObject:item[@"items"][i]];
            }
        }
    } else if (item[@"key"]) {
        NSInteger index = [[self.filter valueForKey:item[@"key"]] integerValue];
        [texts addObject:item[@"items"][index]];
    }
    
    if (texts.count == 0)
        return @"Не выбрано";
    
    if (texts.count == 1)
        return [NSString stringWithFormat:@"%@%@",
                [item[@"only"] boolValue] ? @"Только " : @"",
                texts.lastObject];
    
    if (texts.count == 2)
        return [[texts componentsJoinedByString:@" и "] stringWithCapitalizedFirstCharOnly];
    
    return [[texts componentsJoinedByString:@", "] stringWithCapitalizedFirstCharOnly];
}

- (void)presentChoiseControllerForItem:(NSDictionary *)item completion:(void(^)())completion
{
    ABMultiValuePickerController *controller = [[ABMultiValuePickerController alloc] init];
    controller.view.tintColor = self.view.tintColor;
    controller.allowMultipleSelection = [item[@"multiple"] boolValue];
    controller.allowNoneSelection = [item[@"none"] boolValue];
    controller.title = item[@"title"];
    controller.items = item[@"items"];
    if (item[@"keys"]) {
        for (NSInteger i = 0; i < [item[@"items"] count]; i++) {
            if ([[self.filter valueForKey:item[@"keys"][i]] boolValue])
                [controller.selectedItems addObject:controller.items[i]];
        }
    } else if (item[@"key"]) {
        NSInteger index = [[self.filter valueForKey:item[@"key"]] integerValue];
        [controller.selectedItems addObject:controller.items[index]];
    }
    
    __weak typeof(controller) weakController = controller;
    controller.completion = ^(){
        if (item[@"keys"]) {
            for (NSInteger i = 0; i < [item[@"items"] count]; i++) {
                [self.filter setValue:@([weakController.selectedItems containsObject:weakController.items[i]]) forKey:item[@"keys"][i]];
            }
        } else if (item[@"key"]) {
            [self.filter setValue:@([weakController.items indexOfObject:weakController.selectedItem]) forKey:item[@"key"]];
        }
        if (completion)
            completion();
    };
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)setupCellAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)setupCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
}

@end
