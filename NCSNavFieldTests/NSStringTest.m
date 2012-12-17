//
//  NSStringTest.m
//  NCSNavField
//
//  Created by John Dzak on 12/16/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NSStringTest.h"
#import "NSString+Additions.h"

@implementation NSStringTest

- (void)testIsEqualIgnoreCaseToString {
    STAssertTrue([@"foo" isEqualIgnoreCaseToString:@"FOO"], nil);
}

- (void)testIsEqualIgnoreCaseToStringWhenSameCase {
    STAssertTrue([@"foo" isEqualIgnoreCaseToString:@"foo"], nil);
}

@end
