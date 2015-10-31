//
//  ViewController.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "PinderServer.h"
#import "ABPinderView.h"
#import "ViewController.h"

@interface ViewController () <ABPinderViewDataSource>

@property (nonatomic, weak) IBOutlet ABPinderView *pinderView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.pinderView.count = 3;
        self.pinderView.offset = 12;
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([PinderServer sharedServer].user_id == nil &&
        [PinderServer sharedServer].server_token == nil)
    {
        [self performSegueWithIdentifier:@"segue_login" sender:self];
    }
}

#pragma mark - Pinder

- (NSInteger)numberOfItemsInPinderView:(ABPinderView *)tinderView
{
    return 100;
}

#pragma mark - Navigation

- (IBAction)back:(UIStoryboardSegue *)segue
{
}

@end
