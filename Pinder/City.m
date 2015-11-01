//
//  City.m
//  Pinder
//
//  Created by Anton Bukov on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import "PinderServer.h"
#import "Country.h"
#import "City.h"

@implementation City

+ (FEMMapping *)mapping
{
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"City"];
    [mapping addAttributesFromArray:@[@"title"]];
    mapping.primaryKey = @"city_id";
    [mapping addAttributesFromDictionary:@{@"city_id": @"id"}];
    
    FEMMapping *fakeCountryMapping = [[FEMMapping alloc] initWithEntityName:@"Country"];
    fakeCountryMapping.primaryKey = @"country_id";
    [fakeCountryMapping addAttributesFromDictionary:@{@"country_id": @"country_id"}];
    [mapping addRelationshipMapping:fakeCountryMapping forProperty:@"country" keyPath:nil];
    
    return mapping;
}

+ (NSArray *)allCitiesInCountryIndex:(NSInteger)countryIndex
{
    if (countryIndex == -1)
        return @[];
    return [City MR_findAllSortedBy:@"title" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"country = %@",[Country allCountries][countryIndex]]];
}

@end
