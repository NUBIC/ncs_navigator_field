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
    STAssertEqualObjects(p1.name, @"New Person #1", nil);
    Person* p2 = [Person person];
    STAssertEqualObjects(p2.name, @"New Person #2", nil);
}

@end
