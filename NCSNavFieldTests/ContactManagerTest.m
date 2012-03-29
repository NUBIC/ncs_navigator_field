//
//  ContactManagerTest.m
//  NCSNavField
//
//  Created by John Dzak on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactManagerTest.h"
//#import "ContactManager.h"
#import "Contact.h"
#import "Fixtures.h"

@implementation ContactManagerTest

Contact *c1, *c2, *c3, *c4;
Person *tom, *jen;
NSArray *contacts;

- (void)setUp
{
    [super setUp];

    tom = [Fixtures createPersonWithId:@"T1" name:@"Tom"];
    jen = [Fixtures createPersonWithId:@"J9" name:@"Jen"];

    
    c1 = [Fixtures createContactWithName:@"Collect Soil" 
                  startDate:[Fixtures createDateFromString:@"2010-12-08 09:30"]
                  person: tom];
    
    c2 = [Fixtures createContactWithName:@"Blood Draw" 
                startDate:[Fixtures createDateFromString:@"2010-12-08 09:30"]
                person:tom];
    
    c3 = [Fixtures createContactWithName:@"Something" 
                startDate:[Fixtures createDateFromString:@"2010-12-09 10:00"]
                person:tom];
    
    c4  = [Fixtures createContactWithName:@"Something different" 
                startDate:[Fixtures createDateFromString:@"2010-12-09 10:00"]
                person:jen];
    
    contacts = [NSArray arrayWithObjects: c1, c2, c3, c4, nil];    
}

- (void)tearDown
{
    [super tearDown];
}

//- (void)testCombineByPersonAndDate {
//    NSArray *actual = [ContactManager coalesce:contacts];
//    STAssertEquals([actual count], 3U, @"Wrong number of contacts");
//}

@end
