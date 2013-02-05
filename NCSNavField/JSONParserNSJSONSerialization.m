//
//  NativeJSONParser.m
//  NCSNavField
//
//  Created by John Dzak on 2/4/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "JSONParserNSJSONSerialization.h"

@implementation JSONParserNSJSONSerialization

- (NSDictionary *)objectFromString:(NSString *)string error:(NSError **)error {
    RKLogTrace(@"string='%@'", string);
    return [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:nil error:error];
}

- (NSString *)stringFromObject:(id)object error:(NSError **)error {
    NSData* d = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
}


@end
