//
//  University.h
//  Pinder
//
//  Created by Anton Bukov on 01.11.15.
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
+ (NSArray *)allUniversitiesInCityIndex:(NSInteger)cityIndex countryIndex:(NSInteger)countryIndex;

@end

NS_ASSUME_NONNULL_END

#import "University+CoreDataProperties.h"
