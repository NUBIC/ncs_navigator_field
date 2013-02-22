//
//  Response.m
//  NCSNavField
//
//  Created by John Dzak on 2/1/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "Response.h"
#import "NUAnswer.h"

@implementation Response

@dynamic answer, question, uuid, value;

- (NSDictionary*) toDict {
    NSDictionary* dict = [super toDict];
    [dict setValue:[self coercedValue] forKey:@"value"];
    return dict;
}

- (NSObject*)coercedValue {
    NSObject* coerced = self.value;
    if (coerced) {
        NUAnswer* a = [NUAnswer findFirstByAttribute:@"uuid" withValue:[self valueForKey:@"answer"]];
        if ([a.type isEqualToString:@"integer"]) {
            coerced = [NSNumber numberWithInteger:[self.value integerValue]];
        } else if ([a.type isEqualToString:@"float"]) {
            coerced = [NSDecimalNumber decimalNumberWithString:self.value];
        }
    }
    return coerced;

}

@end
