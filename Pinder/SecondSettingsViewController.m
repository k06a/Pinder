//
//  SecondSettingsViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "SecondSettingsViewController.h"

@interface SecondSettingsViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *mutualFriendsSwitch;

@end

@implementation SecondSettingsViewController

- (IBAction)mutualFriendsSwitchChanged:(UISwitch *)mutualFriendsSwitch
{
    self.filter.in_friends = @(mutualFriendsSwitch.on);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mutualFriendsSwitch.on = self.filter.in_friends.boolValue;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}

@end
