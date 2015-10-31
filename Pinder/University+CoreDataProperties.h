//
//  University+CoreDataProperties.h
//  Pinder
//
//  Created by Антон Буков on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "University.h"

NS_ASSUME_NONNULL_BEGIN

@interface University (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *university_id;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) City *city;
@property (nullable, nonatomic, retain) NSSet<User *> *users;

@end

@interface University (CoreDataGeneratedAccessors)

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet<User *> *)values;
- (void)removeUsers:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
