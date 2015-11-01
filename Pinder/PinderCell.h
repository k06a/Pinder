//
//  PinderCell.h
//  Pinder
//
//  Created by Anton Bukov on 01.11.15.
//  Copyright (c) 2015 Happy Santa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LiveFrost/LiveFrost.h>
#import "User.h"

@interface PinderCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *mainView;
@property (nonatomic, weak) IBOutlet UIImageView *avatarView;
@property (nonatomic, weak) IBOutlet LFGlassView *blurView;
@property (nonatomic, weak) IBOutlet UIImageView *likeSplash;
@property (nonatomic, weak) IBOutlet UIImageView *skipSplash;

@property (nonatomic, strong) User *user;

@end
