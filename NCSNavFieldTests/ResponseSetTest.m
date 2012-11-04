//
//  ResponseSetTest.m
//  NCSNavField
//
//  Created by John Dzak on 8/31/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ResponseSetTest.h"
#import "ResponseSet.h"

@implementation ResponseSetTest

- (void)testSetPid {
    ResponseSet *r = [ResponseSet object];
    [r setValue:@"1d" forKey:@"pId"];
    NSError* error = nil;
    [self.ctx save:&error];
    STAssertNil(error, @"Should save successfully");
    STAssertEqualObjects([r valueForKey:@"pId"], @"1d", @"Wrong pId");    
}

- (void)testToDictWithPid {
    ResponseSet *r = [ResponseSet object];
    [r setValue:@"1d" forKey:@"pId"];
    STAssertEqualObjects([[r toDict] objectForKey:@"p_id"], @"1d", @"Wrong p_id");
}

- (void)testFromJsonWithPid {
    ResponseSet *r = [ResponseSet object];
    [r fromJson:@"{\"p_id\":\"1d\"}"];
    STAssertEqualObjects([r valueForKey:@"pId"], @"1d", @"Wrong pId");
}

@end
