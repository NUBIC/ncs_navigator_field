//
//  MergeStatusTest.m
//  NCSNavField
//
//  Created by John Dzak on 9/28/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "MergeStatusTest.h"
#import "MergeStatus.h"

@implementation MergeStatusTest

- (void)testParseFromJson {
    MergeStatus* m = [MergeStatus parseFromJson:@"{\"status\":\"merged\"}"];
    STAssertEqualObjects(m.status, @"merged", @"Status is wrong");
}

- (void)testParseFromJsonWithNull {
    MergeStatus* m = [MergeStatus parseFromJson:@"{\"status\":null}"];
    STAssertEqualObjects(m.status, nil, @"Status is wrong");
}

@end
