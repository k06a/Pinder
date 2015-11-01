//
//  PinderCell.m
//  Pinder
//
//  Created by Anton Bukov on 01.11.15.
//  Copyright (c) 2015 Happy Santa. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "PinderCell.h"

@interface PinderCell ()

@end

@implementation PinderCell

- (void)awakeFromNib
{
    //self.layer.cornerRadius = 6;
    //self.layer.masksToBounds = YES;
    
    self.mainView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.mainView.layer.shouldRasterize = YES;
    self.mainView.layer.masksToBounds = YES;
    self.mainView.layer.cornerRadius = 6;
    self.mainView.layer.borderWidth = 1.0;
    self.mainView.layer.borderColor = [UIColor colorWithWhite:204/255. alpha:1.0].CGColor;
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.shouldRasterize = YES;
    //self.avatarView.backgroundColor = [UIColor colorWithRed:(rand()%255)/255. green:(rand()%255)/255. blue:(rand()%255)/255. alpha:1.0];
    
    self.clipsToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.25;
    self.layer.shadowOffset = CGSizeMake(0,1);
}

- (void)setUser:(User *)user
{
    _user = user;
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:user.photo_max_orig]];
}

@end
