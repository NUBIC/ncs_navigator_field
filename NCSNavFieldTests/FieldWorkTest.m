//
//  FieldWorkTest.m
//  NCSNavField
//
//  Created by John Dzak on 3/21/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldWorkTest.h"
#import "FieldWork.h"
#import "RestKit.h"

@implementation FieldWorkTest

// All code under test must be linked into the Unit Test bundle
- (void)testGoodIdentifier
{
    FieldWork* f = [FieldWork object];
    f.uri = @"http://foo.com:123/api/v1/fieldwork/xyz123?foo=bar";
    STAssertEqualObjects(@"xyz123", f.fieldWorkId, @"Should be equal");
}

- (void)testBadIdentifier
{
    FieldWork* f = [FieldWork object];
    f.uri = @"";
    STAssertEqualObjects(NULL, f.fieldWorkId, @"Should be equal");
}


@end
