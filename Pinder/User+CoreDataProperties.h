//
//  User+CoreDataProperties.h
//  Pinder
//
//  Created by Антон Буков on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *about;
@property (nullable, nonatomic, retain) NSString *access_token;
@property (nullable, nonatomic, retain) NSString *bdate;
@property (nullable, nonatomic, retain) NSNumber *city_id;
@property (nullable, nonatomic, retain) NSString *domain;
@property (nullable, nonatomic, retain) NSString *first_name;
@property (nullable, nonatomic, retain) NSNumber *identifier;
@property (nullable, nonatomic, retain) NSNumber *in_app;
@property (nullable, nonatomic, retain) NSString *last_name;
@property (nullable, nonatomic, retain) NSString *photo_50;
@property (nullable, nonatomic, retain) NSString *photo_100;
@property (nullable, nonatomic, retain) NSString *photo_200;
@property (nullable, nonatomic, retain) NSString *photo_200_orig;
@property (nullable, nonatomic, retain) NSString *photo_max_orig;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) NSNumber *sort_id;
@property (nullable, nonatomic, retain) NSNumber *user_id;
@property (nullable, nonatomic, retain) NSString *age;
@property (nullable, nonatomic, retain) City *city;
@property (nullable, nonatomic, retain) Country *country;
@property (nullable, nonatomic, retain) University *university;

@end

NS_ASSUME_NONNULL_END
