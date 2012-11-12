//
//  HumanReadablePublicIdGenerator.m
//  NCSNavField
//
//  Created by John Dzak on 11/12/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "HumanReadablePublicIdGeneratorTest.h"
#import "HumanReadablePublicIdGenerator.h"

@implementation HumanReadablePublicIdGeneratorTest

- (void)testHumanReadable {
    NSString* expectedCharClass = @"[2-9abcdefhkrstwxyz]";
    
    NSString* expected = [NSString stringWithFormat:@"^%@{3}-%@{2}-%@{4}$", expectedCharClass, expectedCharClass, expectedCharClass];
    NSString* actual = [HumanReadablePublicIdGenerator createPublicId];
    STAssertTrue([actual rangeOfString:expected options:NSRegularExpressionSearch].location != NSNotFound, @"Should follow format XXX-XX-XXXX");
}

- (void)testHumanReadableIsRandom {
    //defaults to a random human readble ID string
}

- (void)testHumanReadableGetsNewIdWhenCollision {
    // defaults to a nine-character dash-separated string
}


@end
