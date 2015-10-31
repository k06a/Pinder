//
//  University.m
//  Pinder
//
//  Created by Антон Буков on 01.11.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import <FastEasyMapping/FastEasyMapping.h>
#import "PinderServer.h"
#import "University.h"
#import "City.h"

@implementation University

+ (FEMMapping *)mapping
{
    FEMMapping *mapping = [[FEMMapping alloc] initWithEntityName:@"University"];
    [mapping addAttributesFromArray:@[@"title"]];
    mapping.primaryKey = @"university_id";
    [mapping addAttributesFromDictionary:@{@"university_id": @"id"}];
    
    FEMMapping *fakeCityMapping = [[FEMMapping alloc] initWithEntityName:@"City"];
    fakeCityMapping.primaryKey = @"city_id";
    [fakeCityMapping addAttributesFromDictionary:@{@"city_id": @"id"}];
    [mapping addRelationshipMapping:fakeCityMapping forProperty:@"city" keyPath:nil];
    
    return mapping;
}

@end
