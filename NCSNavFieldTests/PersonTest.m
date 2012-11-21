//
//  PersonTest.m
//  NCSNavField
//
//  Created by John Dzak on 11/2/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "PersonTest.h"
#import "Person.h"

@implementation PersonTest

- (void)testNewPersons {
    Person* p1 = [Person person];
    STAssertEqualObjects(p1.firstName, @"New Person #1", nil);
    Person* p2 = [Person person];
    STAssertEqualObjects(p2.firstName, @"New Person #2", nil);
}

- (void)testAddressLineOne {
    Person* p = [Person object];
    p.street = @"123 Oak St";
    STAssertEqualObjects([p addressLineOne], @"123 Oak St", nil);
}

- (void)testAddressLineOneWithBlankStreet {
    Person* p = [Person object];
    p.street = @"";
    STAssertEqualObjects([p addressLineOne], nil, nil);
}

- (void)testAddressLineOneWithNilStreet {
    Person* p = [Person object];
    p.street = nil;
    STAssertEqualObjects([p addressLineOne], nil, nil);
}

- (void)testAddressLineTwo {
    Person* p = [Person object];
    p.city = @"Chicago";
    p.state = @"IL";
    p.zipCode = @"60611";
    STAssertEqualObjects([p addressLineTwo], @"Chicago IL 60611", nil);
}

- (void)testAddressLineTwoWithNilStateAndZip {
    Person* p = [Person object];
    p.city = @"Chicago";
    STAssertEqualObjects([p addressLineTwo], @"Chicago", nil);
}

- (void)testAddressLineTwoWithNilCityStateAndZip {
    Person* p = [Person object];
    STAssertEqualObjects([p addressLineTwo], nil, nil);
}

- (void)testFormattedAddress {
    Person* p = [Person object];
    p.street = @"123 Oak St";
    p.city = @"Chicago";
    p.state = @"IL";
    p.zipCode = @"60611";
    NSString* expected =
        @"123 Oak St\n"
        @"Chicago IL 60611";
    STAssertEqualObjects([p formattedAddress], expected, nil);
}

- (void)testFormattedAddressWhenAllNil {
    Person* p = [Person object];
    STAssertEqualObjects([p formattedAddress], nil, nil);
}

@end
