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
#import "NSDate+Additions.h"

@implementation ContactTest

Contact* c;

- (void)setUp
{
    [super setUp];
    
    c = [Fixtures createContactWithName:@"Birthday" startDate:[Fixtures createDateFromString:@"2010-12-08 00:00"]];
    c.startTime = [Fixtures createTimeFromString:@"10:45"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testContactDateString {
    STAssertEqualObjects([[c date] jsonSchemaDate], @"2010-12-08", @"Wrong value");
}

- (void)testContactStartTimeString {
    STAssertEqualObjects([[c startTime] jsonSchemaTime], @"10:45", @"Wrong value");
}
@end
