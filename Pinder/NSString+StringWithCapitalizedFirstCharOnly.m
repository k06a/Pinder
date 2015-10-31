//
//  NSString+StirngWithCapitalizedFirstCharOnly.m
//  Pinder
//
//  Created by Антон Буков on 31.10.15.
//  Copyright © 2015 Happy Santa. All rights reserved.
//

#import "NSString+StringWithCapitalizedFirstCharOnly.h"

@implementation NSString (StringWithCapitalizedFirstCharOnly)

- (instancetype)stringWithCapitalizedFirstCharOnly
{
    NSString *first = [[self substringToIndex:MIN(1,self.length)] capitalizedString];
    return [self stringByReplacingCharactersInRange:NSMakeRange(0, first.length) withString:first];
}

@end
