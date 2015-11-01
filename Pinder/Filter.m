//
//  Filter.m
//  Pinder
//
//  Created by Anton Bukov on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import "User.h"
#import "Country.h"
#import "City.h"
#import "University.h"
#import "Filter.h"

@implementation Filter

+ (instancetype)sharedFilter
{
    static Filter *filter;
    if (filter == nil) {
        filter = [Filter MR_findFirst];
        if (filter == nil) {
            filter = [Filter MR_createEntity];
            filter.sex_m = @([[User me].sex integerValue] == SexWoman);
            filter.sex_w = @([[User me].sex integerValue] == SexMan);
            filter.country_index = @-1;
            filter.city_index = @-1;
            filter.university_index = @-1;
            filter.relationships_index = @0;
            filter.age_from = @14;
            filter.age_to = @80;
        }
    }
    return filter;
}

- (NSDictionary *)jsonObject
{
    id sex = ^id{
        if (self.sex_w.boolValue && !self.sex_m.boolValue)
            return @1;
        if (!self.sex_w.boolValue && self.sex_m.boolValue)
            return @2;
        return [NSNull null];
    }();
    id country_id = ^id{
        if (self.country_index.integerValue == -1)
            return (id)[NSNull null];
        return [[Country allCountries][self.country_index.integerValue] country_id];
    }();
    id city_id = ^id{
        if (self.city_index.integerValue == -1)
            return (id)[NSNull null];
        return [[City allCitiesInCountryIndex:self.country_index.integerValue][self.city_index.integerValue] city_id];
    }();
    id university_id = ^id{
        if (self.university_index.integerValue == -1)
            return (id)[NSNull null];
        return [[University allUniversitiesInCityIndex:self.city_index.integerValue countryIndex:self.country_index.integerValue][self.university_index.integerValue] university_id];
    }();
    return @{@"country_id":country_id,
             @"city_id":city_id,
             @"university_id":university_id,
             @"sex":sex,
             @"status":self.relationships_index,
             @"age_from":self.age_from,
             @"age_to":self.age_to,
             @"online":self.online,
             @"in_friends":self.in_friends ?: @0,
             };
}

@end
