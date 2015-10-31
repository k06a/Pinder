//
//  SettingsViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

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

@end
