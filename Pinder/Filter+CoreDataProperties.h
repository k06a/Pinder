//
//  Filter+CoreDataProperties.h
//  Pinder
//
//  Created by Антон Буков on 31.10.15.
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

@end

NS_ASSUME_NONNULL_END
