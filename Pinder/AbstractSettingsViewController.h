//
//  AbstractSettingsViewController.h
//  Pinder
//
//  Created by Anton Bukov on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pinder.h"

@interface AbstractSettingsViewController : UITableViewController

@property (nonatomic, strong) Filter *filter;
@property (nonatomic, strong) NSDictionary *items;

@property (nonatomic, strong) NSArray *countries;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *universities;

- (NSString *)descriptionForItem:(NSDictionary *)item;
- (void)presentChoiseControllerForItem:(NSDictionary *)item completion:(void(^)())completion;

- (void)setupCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)setupCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;

@end
