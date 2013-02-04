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

@dynamic value;

- (NSDictionary*) toDict {
    NSDictionary* dict = [super toDict];
    [dict setValue:[self coercedValue] forKey:@"value"];
    return dict;
}

- (NSObject*)coercedValue {
    NSObject* coerced = self.value;
    NUAnswer* a = [NUAnswer findFirstByAttribute:@"uuid" withValue:[self valueForKey:@"answer"]];
    if ([a.type isEqualToString:@"integer"]) {
        coerced = [NSNumber numberWithInteger:[self.value integerValue]];
    }
    return coerced;

}

@end
