//
//  HumanReadablePublicIdGenerator.m
//  NCSNavField
//
//  Created by John Dzak on 11/12/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "HumanReadablePublicIdGenerator.h"

#import <MRCEnumerable/MRCEnumerable.h>

@implementation Random

+ (NSUInteger)randWithLimit:(NSUInteger)limit{
    return arc4random_uniform(limit);
}

@end

@implementation HumanReadablePublicIdGenerator

+ (NSArray*)chars {
    return @[@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f", @"h", @"k", @"r", @"s", @"t", @"w", @"x", @"y", @"z"];
    
}
+ (NSString*)generate {
    NSArray* CHARS = [HumanReadablePublicIdGenerator chars];
    NSArray* PATTERN = @[@3, @2, @4];

    return [[PATTERN collect:^id(id obj) {
        NSUInteger segmentLength = [obj unsignedIntValue];
        NSUInteger rand = [Random randWithLimit:powl([CHARS count], segmentLength)];
        return [self toCharsWithRandom:rand segmentLength:segmentLength];
    }] componentsJoinedByString:@"-"];
}

+ (NSString*)toCharsWithRandom:(NSUInteger)rand segmentLength:(NSUInteger)segmentLength {
    NSArray* CHARS = [HumanReadablePublicIdGenerator chars];
    
    NSMutableString* converted = [NSMutableString new];
    while (rand > 0) {
        [converted appendString:CHARS[(rand % [CHARS count])]];
        rand /= [CHARS count];
    }
    NSString* format = [NSString stringWithFormat:@"%%%ds", segmentLength];
    NSString* formatted = [NSString stringWithFormat:format, [converted UTF8String]];
    return [formatted stringByReplacingOccurrencesOfString:@" " withString:CHARS[0]];
}

@end
