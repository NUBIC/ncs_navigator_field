//
//  ContactTest.m
//  NCSNavField
//
//  Created by John Dzak on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactTest.h"
#import "Fixtures.h"
#import "Contact.h"
#import "Event.h"
#import "Person.h"

@implementation ContactTest

Event *e1, *e2;
Person *tom, *jen;

- (void)setUp
{
    [super setUp];
    
    e1 = [Fixtures createEventWithName:@"Collect Soil" 
                   date:[Fixtures createDateFromString:@"2010-12-08 09:30"]];

    e2 = [Fixtures createEventWithName:@"Something else" 
                   date:[Fixtures createDateFromString:@"2010-12-08 10:30"]];
    
    tom = [Fixtures createPersonWithId:@"T1" name:@"Tom"];
    jen = [Fixtures createPersonWithId:@"J9" name:@"Jen"];
}

- (void)tearDown
{
    [super tearDown];
}

@end
