//
//  University.h
//  Pinder
//
//  Created by Антон Буков on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PinderForward.h"

@class City;
@class FEMMapping;

NS_ASSUME_NONNULL_BEGIN

@interface University : NSManagedObject

+ (FEMMapping *)mapping;

@end

NS_ASSUME_NONNULL_END

#import "University+CoreDataProperties.h"
