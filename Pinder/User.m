//
//  User.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import "PinderServer.h"
#import "User.h"

@implementation User

+ (FEMMapping *)mapping
{
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"User"];
    [mapping addAttributesFromArray:@[@"user_id", @"in_app", @"access_token", @"identifier", @"first_name", @"last_name", @"sex", @"bdate", @"city_id", @"photo_50", @"photo_100", @"photo_200_orig", @"photo_200", @"photo_max_orig", @"domain", @"about"]];
    [mapping addAttributesFromDictionary:@{@"identifier": @"id"}];
    mapping.primaryKey = @"identifier";
    
    FEMMapping *fakeCountryMapping = [[FEMMapping alloc] initWithEntityName:@"Country"];
    fakeCountryMapping.primaryKey = @"country_id";
    [fakeCountryMapping addAttributesFromDictionary:@{@"country_id": @"country_id"}];
    [mapping addRelationshipMapping:fakeCountryMapping forProperty:@"country" keyPath:nil];
    
    FEMMapping *fakeCityMapping = [[FEMMapping alloc] initWithEntityName:@"City"];
    fakeCityMapping.primaryKey = @"city_id";
    [fakeCityMapping addAttributesFromDictionary:@{@"city_id": @"city_id"}];
    [mapping addRelationshipMapping:fakeCityMapping forProperty:@"city" keyPath:nil];
    
    FEMMapping *fakeUniversityMapping = [[FEMMapping alloc] initWithEntityName:@"City"];
    fakeUniversityMapping.primaryKey = @"university_id";
    [fakeUniversityMapping addAttributesFromDictionary:@{@"university_id": @"university_id"}];
    [mapping addRelationshipMapping:fakeUniversityMapping forProperty:@"university" keyPath:nil];
    
    return mapping;
}

+ (int64_t)nextSortId
{
    return [[User MR_findFirstOrderedByAttribute:@"sort_id" ascending:NO].sort_id longLongValue] + 1;
}

+ (instancetype)me
{
    return [User MR_findFirstByAttribute:@"identifier" withValue:@([[PinderServer sharedServer].user_id longLongValue])];
}

@end
