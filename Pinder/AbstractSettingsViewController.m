//
//  AbstractSettingsViewController.m
//  Pinder
//
//  Created by Anton Bukov on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "NSString+StringWithCapitalizedFirstCharOnly.h"
#import "ABMultiValuePickerController.h"

#import "PinderServer.h"
#import "AbstractSettingsViewController.h"

@interface AbstractSettingsViewController ()

@end

@implementation AbstractSettingsViewController

- (Filter *)filter
{
    if (_filter == nil)
        _filter = [Filter sharedFilter];
    return _filter;
}

- (NSArray *)countries
{
    if (_countries == nil)
        _countries = [Country allCountries];
    return _countries;
}

- (NSArray *)cities
{
    return [City allCitiesInCountryIndex:self.filter.country_index.integerValue];
}

- (NSArray *)universities
{
    return [University allUniversitiesInCityIndex:self.filter.city_index.integerValue countryIndex:self.filter.country_index.integerValue];
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
        if (index != -1 && index < [item[@"items"] count])
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
        if (index != -1 && index < controller.items.count)
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
