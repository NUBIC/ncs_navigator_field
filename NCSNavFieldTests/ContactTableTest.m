//
//  ContactPresenterTest.m
//  NCSNavField
//
//  Created by John Dzak on 9/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactTableTest.h"
#import "ContactTable.h"
#import "Fixtures.h"
#import "Contact.h"
#import "Event.h"
#import "Person.h"
#import "Section.h"
#import "Row.h"

@implementation ContactTableTest

Contact *c;
Person *tom;

- (void)setUp
{
    [super setUp];
    
    tom = [Fixtures createPersonWithId:@"T1" name:@"Tom"];
    tom.street = @"1 Sesame St";
    tom.city = @"Chicago";
    tom.zipCode = @"60611";
    tom.cellPhone = @"111-222-3333";
    tom.email = @"tom@jones.com";
    
    
    c = [Fixtures createContactWithDate:[Fixtures createDateFromString:@"2010-12-08 09:30"]];
    c.person = tom;
    [c addEventsObject:[self buildEvent:@"Birth"]];
}

- (void)testSections {
    NSArray* sections = [self generateSections];
    STAssertEquals([sections count], 4U, @"Wrong number of sections");
}

- (void) testContactSection {
    NSArray* sections = [self generateSections];
    Section* s3 = [sections objectAtIndex:3];
    STAssertEqualObjects(s3.name, @"Contact", @"Wrong value");
    STAssertEquals([s3.rows count], 1U, @"Wrong number of rows");
}

- (void) testStartContactRow {
    NSArray* sections = [self generateSections];
    Section* s3 = [sections objectAtIndex:3];
    Row* s3r0 = [s3.rows objectAtIndex:0];
    STAssertEqualObjects(s3r0.text, @"Start Contact", @"Wrong value");    
}

- (void) testContinueContactRow {
    c.initiated = YES;
    NSArray* sections = [self generateSections];
    Section* s3 = [sections objectAtIndex:3];
    Row* s3r0 = [s3.rows objectAtIndex:0];
    STAssertEqualObjects(s3r0.text, @"Continue Contact", @"Wrong value");
}

- (void)testBirthInstrument {
    c.initiated = YES;
    NSArray* sections = [self generateSections];
    Section* s4 = [sections objectAtIndex:4];
    Row* s4r0 = [s4.rows objectAtIndex:0];
    Row* s4r1 = [s4.rows objectAtIndex:1];
    STAssertEquals([sections count], 5U, @"Wrong number of sections");
    STAssertEqualObjects(s4.name, @"Birth Event", @"Wrong value");
    STAssertEqualObjects(s4r0.text, @"Birth Instrument", @"Wrong value");
    STAssertEqualObjects(s4r1.text, @"Birth Instrument Details", @"Wrong value");
}

- (void)testPregnancyAndBirthInstruments {
    [c addEventsObject:[self buildEvent:@"Pregnancy"]];
    c.initiated = YES;
    NSArray* sections = [self generateSections];
    Section* s4 = [sections objectAtIndex:4];
    Section* s5 = [sections objectAtIndex:5];
    Row* s4r0 = [s4.rows objectAtIndex:0];
    Row* s4r1 = [s4.rows objectAtIndex:1];
    Row* s5r0 = [s5.rows objectAtIndex:0];
    Row* s5r1 = [s5.rows objectAtIndex:1];
    STAssertEquals([sections count], 6U, @"Wrong number of sections");
    STAssertEqualObjects(s4.name, @"Birth Event", @"Wrong value");
    STAssertEqualObjects(s4r0.text, @"Birth Instrument", @"Wrong value");
    STAssertEqualObjects(s4r1.text, @"Birth Instrument Details", @"Wrong value");
    STAssertEqualObjects(s5.name, @"Pregnancy Event", @"Wrong value");
    STAssertEqualObjects(s5r0.text, @"Pregnancy Instrument", @"Wrong value");
    STAssertEqualObjects(s5r1.text, @"Pregnancy Instrument Details", @"Wrong value");
}

- (NSArray*) generateSections {
    return [[[ContactTable alloc] initUsingContact:c] sections];
}

- (Event*) buildEvent:(NSString*)name {
    Event* e = [Fixtures createEventWithName:[NSString stringWithFormat:@"%@ Event", name]];
    [e addInstrumentsObject:[Fixtures createInstrumentWithName:[NSString stringWithFormat:@"%@ Instrument", name]]];
    return e;
}

@end
