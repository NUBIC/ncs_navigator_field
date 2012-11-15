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

- (void)testGenerate {
    NSString* expectedCharClass = @"[2-9abcdefhkrstwxyz]";
    
    NSString* expected = [NSString stringWithFormat:@"^%@{3}-%@{2}-%@{4}$", expectedCharClass, expectedCharClass, expectedCharClass];
    NSString* actual = [HumanReadablePublicIdGenerator generate];
    STAssertTrue([actual rangeOfString:expected options:NSRegularExpressionSearch].location != NSNotFound, @"%@ should follow format XXX-XX-XXXX", actual);
}

- (void)testHumanReadableIsRandom {
    NSSet* all = [NSSet setWithObjects:
                    [HumanReadablePublicIdGenerator generate],
                    [HumanReadablePublicIdGenerator generate],
                    [HumanReadablePublicIdGenerator generate],nil];
    STAssertEquals([all count], 3U, nil);
}

- (void)testHumanReadableGetsNewIdWhenCollision {
    // defaults to a nine-character dash-separated string
}


@end
