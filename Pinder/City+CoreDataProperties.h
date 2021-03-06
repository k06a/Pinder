//
//  City+CoreDataProperties.h
//  Pinder
//
//  Created by Антон Буков on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *city_id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSSet<User *> *users;
@property (nullable, nonatomic, retain) Country *country;
@property (nullable, nonatomic, retain) NSSet<University *> *universities;

@end

@interface City (CoreDataGeneratedAccessors)

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet<User *> *)values;
- (void)removeUsers:(NSSet<User *> *)values;

- (void)addUniversitiesObject:(University *)value;
- (void)removeUniversitiesObject:(University *)value;
- (void)addUniversities:(NSSet<University *> *)values;
- (void)removeUniversities:(NSSet<University *> *)values;

@end

NS_ASSUME_NONNULL_END
