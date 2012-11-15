//
//  NSDate+Additions.m
//  NCSNavField
//
//  Created by John Dzak on 4/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

- (NSString*)jsonSchemaDate {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy'-'MM'-'dd"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    return [f stringFromDate:self];
}

- (NSString*)jsonSchemaTime {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH':'mm"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    return [f stringFromDate:self];    
}

-(NSString*)toRFC3339 {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [f setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [f setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    /*NSDateFormatter* df3339 = [[NSDateFormatter alloc] init];
    [df3339 setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [df3339 setDateFormat:@"yyyy'-'MM'-'dd"];
    [df3339 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];*/
    return [f stringFromDate:self];
}

-(NSString*)toYYYYYMMDD {
     NSDateFormatter* f = [[NSDateFormatter alloc] init];
     [f setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
     [f setDateFormat:@"yyyy'-'MM'-'dd"];
     [f setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
     return [f stringFromDate:self];

}

@end
