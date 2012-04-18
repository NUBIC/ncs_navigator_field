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
    
    
    
    c = [Fixtures createContactWithName:@"Collect Soil" 
                               startDate:[Fixtures createDateFromString:@"2010-12-08 09:30"]];
    c.person = tom;
    
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


- (NSArray*) generateSections {
    return [[[ContactTable alloc] initUsingContact:c] sections];
}

@end
