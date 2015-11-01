//
//  Country.m
//  Pinder
//
//  Created by Anton Bukov on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import "PinderServer.h"
#import "Country.h"

@implementation Country

+ (FEMMapping *)mapping
{
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"Country"];
    [mapping addAttributesFromArray:@[@"title"]];
    [mapping addAttributesFromDictionary:@{@"country_id": @"id"}];
    mapping.primaryKey = @"country_id";
    return mapping;
}

+ (NSArray *)allCountries
{
    return [Country MR_findAllSortedBy:@"title" ascending:YES];
}

@end
