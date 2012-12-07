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
//nil will return false also:
//http://stackoverflow.com/questions/899209/how-do-i-test-if-a-string-is-empty-in-objective-c
-(BOOL)isEmptyOrNil {
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

@end
