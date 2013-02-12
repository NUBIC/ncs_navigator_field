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
    [[self managedObjectContext] save:&error];
    STAssertNil(error, @"Should save successfully");
    STAssertEqualObjects([r valueForKey:@"pId"], @"1d", @"Wrong pId");    
}

- (void)testToDictWithPid {
    ResponseSet *r = [ResponseSet object];
    [r setValue:@"1d" forKey:@"pId"];
    STAssertEqualObjects([[r toDict] valueForKey:@"p_id"], @"1d", @"Wrong p_id");
}

- (void)testFromJsonWithPid {
    ResponseSet *r = [ResponseSet object];
    [r fromJson:@"{\"p_id\":\"1d\"}"];
    STAssertEqualObjects([r valueForKey:@"pId"], @"1d", @"Wrong pId");
}

- (void)testFromJsonWithInstrumentContext {
    ResponseSet *r = [ResponseSet object];
    [r fromJson:@"{\"instrument_context\": {\"moo\": \"cow\"}}"];
    STAssertEqualObjects(r.instrumentContext[@"moo"], @"cow", nil);
}

- (void)testInstrumentContextWhenNil {
    STAssertEqualObjects(((ResponseSet*)[ResponseSet object]).instrumentContext, @{}, nil);
}

- (void)testSaveInstrumentContextWhenNil {
    ResponseSet *pending = [ResponseSet object];
    [pending setValue:@"im-unique" forKey:@"uuid"];
    [[self managedObjectContext] save:nil];
    
    ResponseSet* actual = [ResponseSet findFirstByAttribute:@"uuid" withValue:@"im-unique"];
    STAssertEqualObjects(actual.instrumentContext, @{}, nil);
}

- (void)testSaveInstrumentContext {
    ResponseSet *pending = [ResponseSet object];
    [pending setValue:@"im-unique" forKey:@"uuid"];
    pending.instrumentContext = @{@"foo": @"bar"};
    NSError* error = nil;
    [[self managedObjectContext] save:&error];
    
    STAssertNil(error, @"Save error: %@", [error description]);
    ResponseSet* actual = [ResponseSet findFirstByAttribute:@"uuid" withValue:@"im-unique"];
    STAssertEqualObjects(actual.instrumentContext[@"foo"], @"bar", nil);
}

@end
