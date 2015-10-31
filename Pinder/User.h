//
//  User.h
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FEMMapping;

enum SexEnum
{
    SexWoman = 1,
    SexMan = 2,
};

//

NS_ASSUME_NONNULL_BEGIN

@interface User : NSManagedObject

- (FEMMapping *)mapping;
+ (int64_t)nextSortId;
+ (instancetype)me;

@end

NS_ASSUME_NONNULL_END

#import "User+CoreDataProperties.h"
