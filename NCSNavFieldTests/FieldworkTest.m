//
//  FieldWorkTest.m
//  NCSNavField
//
//  Created by John Dzak on 3/21/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkTest.h"
#import "Fieldwork.h"
#import "RestKit.h"

@implementation FieldworkTest

// All code under test must be linked into the Unit Test bundle
- (void)testGoodIdentifier
{
    Fieldwork* f = [Fieldwork object];
    f.uri = @"http://foo.com:123/api/v1/fieldwork/xyz123?foo=bar";
    STAssertEqualObjects(@"xyz123", f.fieldworkId, @"Should be equal");
}

- (void)testBadIdentifier
{
    Fieldwork* f = [Fieldwork object];
    f.uri = @"";
    STAssertEqualObjects(NULL, f.fieldworkId, @"Should be equal");
}


@end
