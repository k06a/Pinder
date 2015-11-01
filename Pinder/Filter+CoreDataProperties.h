//
//  Filter+CoreDataProperties.h
//  Pinder
//
//  Created by Антон Буков on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN

@interface Filter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *country_index;
@property (nullable, nonatomic, retain) NSNumber *sex_m;
@property (nullable, nonatomic, retain) NSNumber *sex_w;
@property (nullable, nonatomic, retain) NSNumber *city_index;
@property (nullable, nonatomic, retain) NSNumber *university_index;
@property (nullable, nonatomic, retain) NSNumber *relationships_index;
@property (nullable, nonatomic, retain) NSNumber *filter_id;
@property (nullable, nonatomic, retain) NSNumber *age_from;
@property (nullable, nonatomic, retain) NSNumber *age_to;
@property (nullable, nonatomic, retain) NSNumber *online;

@end

NS_ASSUME_NONNULL_END
