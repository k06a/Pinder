//
//  ValuePickerViewController.h
//  Pinder
//
//  Created by Антон Буков on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ValuePickerViewController : UITableViewController

@property (nonatomic, strong) NSArray<NSString *> *items;
@property (nonatomic, assign) BOOL allowMultipleSelection;

@property (nonatomic, strong) NSString *selectedItem;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectedItems;
@property (nonatomic, assign) BOOL wasCancelled;

@end
