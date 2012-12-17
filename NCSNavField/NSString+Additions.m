//
//  NSString+Additions.m
//  NCSNavField
//
//  Created by John Dzak on 5/3/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSDate*)jsonTimeToDate {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH':'mm"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    return [f dateFromString:self];    
}

-(BOOL)isBlank {
    return self == nil || [self isEqualToString:[NSString string]];
}

-(BOOL)isEmpty {
    return [self length] == 0;
}

-(NSDate*)fromYYYYMMDD {
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [f setDateFormat:@"yyyy'-'MM'-'dd"];
    [f setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [f dateFromString:self];
}

-(NSNumber*)toNumber {
    return [NSNumber numberWithInt:[self intValue]];
}

- (BOOL)isEqualIgnoreCaseToString:(NSString *)aString {
    return [self caseInsensitiveCompare:aString] == NSOrderedSame;
}

@end
