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

+ (NSString*)generate {
    NSArray* const CHARS = @[@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f", @"h", @"k", @"r", @"s", @"t", @"w", @"x", @"y", @"z"];
    
    NSArray* const PATTERN = @[@3, @2, @4];

    return [[PATTERN collect:^id(id obj) {
        NSUInteger segmentLength = [obj unsignedIntValue];
        NSUInteger rand = [Random randWithLimit:powl([CHARS count], segmentLength)];
        return [self toCharsWithRandom:rand segmentLength:segmentLength];
    }] componentsJoinedByString:@"-"];
}

+ (NSString*)toCharsWithRandom:(NSUInteger)rand segmentLength:(NSUInteger)segmentLength {
        NSArray* const CHARS = @[@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"a", @"b", @"c", @"d", @"e", @"f", @"h", @"k", @"r", @"s", @"t", @"w", @"x", @"y", @"z"];
    
    NSMutableString* converted = [NSMutableString new];
    while (rand > 0) {
        [converted appendString:CHARS[(rand % [CHARS count])]];
        rand /= [CHARS count];
    }
    return [[converted substringToIndex:segmentLength] stringByReplacingOccurrencesOfString:@" " withString:CHARS[0]];
}
//
//+ (NSInteger*)prng {
//    @prng = Random.new
//    return prng;
//}


@end
