//
//  Filter.h
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PinderForward.h"

NS_ASSUME_NONNULL_BEGIN

@interface Filter : NSManagedObject

+ (instancetype)sharedFilter;
- (NSDictionary *)jsonObject;

@end

NS_ASSUME_NONNULL_END

#import "Filter+CoreDataProperties.h"
