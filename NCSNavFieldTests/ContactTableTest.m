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
    tom.state = @"IL";
    tom.zipCode = @"60611";
    tom.cellPhone = @"111-222-3333";
    tom.email = @"tom@jones.com";
    
    
    c = [Fixtures createContactWithDate:[Fixtures createDateFromString:@"2010-12-08 09:30"]];
    c.person = tom;
    [c addEventsObject:[self buildEvent:@"Birth" withDate:@"2010-09-17"]];
}

- (void)testSections {
    NSArray* sections = [self generateSections];
    STAssertEquals([sections count], 3U, @"Wrong number of sections");
}

- (void)testSectionsWithContactStarted {
    c.initiated = TRUE;
    NSArray* sections = [self generateSections];
    STAssertEquals([sections count], 5U, @"Wrong number of sections");
}


- (void)testAddress {
    NSArray* sections = [self generateSections];
    Section* s0 = [sections objectAtIndex:0];
    STAssertEqualObjects(s0.name, @"Address", @"Wrong value");
    Row* s0r0 = [s0.rows objectAtIndex:0];
    STAssertEqualObjects(s0r0.text, @"Home", @"Wrong value");
    STAssertEqualObjects(s0r0.detailText, @"1 Sesame St\nChicago IL 60611", @"Wrong value");
}

// TODO: Test address if street, city, state are nil
//       Maybe try different formats.
-(void)testBlankAddress {
    tom.street = nil;
    [self generateSections];
}

- (void) testContactSection {
    NSArray* sections = [self generateSections];
    Section* s2 = [sections objectAtIndex:2];
    STAssertEqualObjects(s2.name, @"Contact", @"Wrong value");
    STAssertEquals([s2.rows count], 1U, @"Wrong number of rows");
}

- (void) testStartContactRow {
    NSArray* sections = [self generateSections];
    Section* s2 = [sections objectAtIndex:2];
    Row* s2r0 = [s2.rows objectAtIndex:0];
    STAssertEqualObjects(s2r0.text, @"Start Contact for Birth", @"Wrong value");    
}

- (void) testContinueContactRow {
    c.initiated = YES;
    NSArray* sections = [self generateSections];
    Section* s2 = [sections objectAtIndex:2];
    Row* s2r0 = [s2.rows objectAtIndex:0];
    STAssertEqualObjects(s2r0.text, @"Continue Contact for Birth", @"Wrong value");
}

- (void)testBirthInstrument {
    c.initiated = YES;
    NSArray* sections = [self generateSections];
    Section* s3 = [sections objectAtIndex:3];
    Row* s3r0 = [s3.rows objectAtIndex:0];
//    Row* s4r1 = [s4.rows objectAtIndex:1];
    STAssertEquals([sections count], 5U, @"Wrong number of sections");
    STAssertEqualObjects(s3.name, @"Scheduled Instruments", @"Wrong value");
    STAssertEqualObjects(s3r0.text, @"Birth Instrument", @"Wrong value");
//    STAssertEqualObjects(s4r1.text, @"Birth Event Activity Details", @"Wrong value");
}

- (void)testPregnancyAndBirthInstrumentsOrder {
    [c addEventsObject:[self buildEvent:@"Pregnancy" withDate:@"2010-10-17"]];
    c.initiated = YES;
    NSArray* sections = [self generateSections];
    Section* s3 = [sections objectAtIndex:3];
    Row* s3r0 = [s3.rows objectAtIndex:0];
    Row* s3r1 = [s3.rows objectAtIndex:1];
    STAssertEquals([sections count], 5U, @"Wrong number of sections");
    STAssertEqualObjects(s3.name, @"Scheduled Instruments", @"Wrong value");
    STAssertEqualObjects(s3r0.text, @"Pregnancy Instrument", @"Wrong value");
    STAssertEqualObjects(s3r1.text, @"Birth Instrument", @"Wrong value");

}



#pragma mark helper methods

- (NSArray*) generateSections {
    return [[[ContactTable alloc] initUsingContact:c] sections];
}

- (Event*) buildEvent:(NSString*)name withDate:(NSString*)date {    
    Event* e = [Fixtures createEventWithName:name];
    e.startDate = [Fixtures createDateFromString:date];
    [e addInstrumentsObject:[Fixtures createInstrumentWithName:name]];
    return e;
}

@end
