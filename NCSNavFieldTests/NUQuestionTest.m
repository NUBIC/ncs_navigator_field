//
//  NUQuestionTest.m
//  NCSNavField
//
//  Created by John Dzak on 2/22/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUQuestionTest.h"
#import "NUQuestion.h"

@implementation NUQuestionTest

- (void)testReferenceIdentifierWithoutHelperPrefix {
    NUQuestion* q = [NUQuestion object];
    q.referenceIdentifier = @"helper_foo";
    STAssertEqualObjects([q referenceIdentifierWithoutHelperPrefix], @"foo", nil);
}

- (void)testReferenceIdentifierWithoutHelperPrefixWithCaps {
    NUQuestion* q = [NUQuestion object];
    q.referenceIdentifier = @"HELPER_FOO";
    STAssertEqualObjects([q referenceIdentifierWithoutHelperPrefix], @"FOO", nil);
}

- (void)testReferenceIdentifierWithoutHelperPrefixWhenMissingHelperPrefix {
    NUQuestion* q = [NUQuestion object];
    q.referenceIdentifier = @"foo";
    STAssertEqualObjects([q referenceIdentifierWithoutHelperPrefix], @"foo", nil);
}

- (void)testReferenceIdentifierWithoutHelperPrefixWhenHelperIsPostfix {
    NUQuestion* q = [NUQuestion object];
    q.referenceIdentifier = @"foo_helper";
    STAssertEqualObjects([q referenceIdentifierWithoutHelperPrefix], @"foo_helper", nil);
}

- (void)testIsHelperQuestion {
    NUQuestion* q = [NUQuestion object];
    q.referenceIdentifier = @"helper_foo";
    STAssertTrue([q isHelperQuestion], nil);
}

- (void)testIsHelperQuestionWithCaps {
    NUQuestion* q = [NUQuestion object];
    q.referenceIdentifier = @"HELPER_FOO";
    STAssertTrue([q isHelperQuestion], nil);
}

- (void)testIsHelperQuestionWhenMissingHelperPrefix {
    NUQuestion* q = [NUQuestion object];
    q.referenceIdentifier = @"foo";
    STAssertFalse([q isHelperQuestion], nil);
}

- (void)testIsHelperQuestionWhenHelperIsPostfix {
    NUQuestion* q = [NUQuestion object];
    q.referenceIdentifier = @"foo_helper";
    STAssertFalse([q isHelperQuestion], nil);
}

@end
