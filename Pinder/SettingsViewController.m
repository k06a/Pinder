//
//  SettingsViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "Pinder.h"
#import "PinderServer.h"
#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;
@property (nonatomic, weak) IBOutlet UIView *view1;
@property (nonatomic, weak) IBOutlet UIView *view2;
@property (nonatomic, weak) IBOutlet UIView *view3;

@end

@implementation SettingsViewController

- (IBAction)segmentValueChanged:(UISegmentedControl *)segmentControl
{
    NSArray<UIView *> *views = @[self.view1, self.view2, self.view3];
    for (NSInteger i = 0; i < 3; i++) {
        views[i].hidden = (i != segmentControl.selectedSegmentIndex);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self segmentValueChanged:self.segmentControl];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.isMovingFromParentViewController) {
        id filter = @{@"filter":[[Filter sharedFilter] jsonObject]};
        [[PinderServer sharedServer] updateFilter:filter completion:^(NSArray *arrUsers, NSDictionary *filter)
        {
            [Filter sharedFilter].filter_id = filter[@"id"];
            NSInteger nextSortId = [User nextSortId];
            NSArray<User *> *users = [FEMDeserializer collectionFromRepresentation:arrUsers mapping:[User mapping] context:[NSManagedObjectContext MR_defaultContext]];
            for (NSInteger i = 0; i < users.count; i++)
                users[i].sort_id = @(nextSortId+i);
        }];
    }
}

@end
