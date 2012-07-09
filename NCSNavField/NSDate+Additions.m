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
    NSDateFormatter* f = [[[NSDateFormatter alloc] init] autorelease];
    [f setDateFormat:@"yyyy'-'MM'-'dd"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    return [f stringFromDate:self];
}

- (NSString*)jsonSchemaTime {
    NSDateFormatter* f = [[[NSDateFormatter alloc] init] autorelease];
    [f setDateFormat:@"HH':'mm"];
    [f setTimeZone:[NSTimeZone localTimeZone]];
    return [f stringFromDate:self];    
}

@end
