//
//  DetailViewPresenterTest.m
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactNavigationTableTest.h"
#import "ContactNavigationTable.h"
#import "Event.h"
#import "Person.h"
#import "Contact.h"
#import "Section.h"
#import "CoreData.h"

@implementation ContactNavigationTableTest

ContactNavigationTable* dvp;

- (void)setUp
{
    [super setUp];
    
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy'-'MM'-'dd'"];
    [f setTimeZone:[NSTimeZone localTimeZone]];

    Contact* c1 = [Contact object];
    c1.date = [f dateFromString:@"2010-12-08"];
    
    Contact* c2 = [Contact object];
    c2.date = [f dateFromString:@"2010-12-08"];
    
    Contact* c3 = [Contact object];
    c3.date = [f dateFromString:@"2010-12-09"];
    
    NSArray *contacts = [NSArray arrayWithObjects:c1, c2, c3, nil];
    dvp = [[ContactNavigationTable alloc] initWithContacts:contacts];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSections {
    NSArray* sections = dvp.sections;
    STAssertEquals([sections count], 2U, @"Wrong number of sections");
    Section* s0 = [sections objectAtIndex:0];
    STAssertEqualObjects(s0.name, @"December 08", @"Wrong value");
    Section* s1 = [sections objectAtIndex:1];
    STAssertEqualObjects(s1.name, @"December 09", @"Wrong value");
}

@end

