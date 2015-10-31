//
//  User.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import "User.h"

@implementation User

- (FEMMapping *)mapping
{
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Person"];
    [mapping addAttributesFromArray:@[@"user_id", @"in_app", @"access_token", @"identifier", @"first_name", @"last_name", @"sex", @"bdate", @"city_id", @"photo_50", @"photo_100", @"photo_200_orig", @"photo_200", @"photo_max_orig", @"domain", @"about"]];
    [mapping addAttributesFromDictionary:@{@"identifier": @"id"}];
    mapping.primaryKey = @"identifier";
    
    //[mapping addRelationshipMapping:[City defaultMapping] forProperty:@"city" keyPath:@"city_id"];
    //[mapping addToManyRelationshipMapping:[Country defaultMapping] forProperty:@"country" keyPath:@"country_id"];
    
    return mapping;
}

+ (int64_t)nextSortId
{
    return [[User MR_findFirstOrderedByAttribute:@"sort_id" ascending:NO].sort_id longLongValue] + 1;
}

@end
