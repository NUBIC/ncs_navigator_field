//
//  ResponseSetMustacheContextTest.m
//  NCSNavField
//
//  Created by John Dzak on 2/20/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "ResponseSetMustacheContextTest.h"
#import "ResponseSet.h"
#import "ResponseSetMustacheContext.h"

@implementation ResponseSetMustacheContextTest

- (void)testToDictionary {
    ResponseSet* rs = [ResponseSet object];
    ResponseSetMustacheContext* ctx = [[ResponseSetMustacheContext alloc] initWithResponseSet:rs];
    NSDictionary* actual = [ctx toDictionary];
    STAssertNotNil(actual, nil);
}
@end
