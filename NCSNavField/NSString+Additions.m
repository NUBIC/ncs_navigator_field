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

@end
