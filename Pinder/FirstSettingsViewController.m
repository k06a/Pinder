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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
