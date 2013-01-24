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
#import "Participant.h"
#import "NSDate+Additions.h"

@implementation ContactTest

Contact* c;

- (void)setUp
{
    [super setUp];
    
    c = [Fixtures createContactWithDate:[Fixtures createDateFromString:@"2010-12-08"]];
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

- (void) testContactDeleteFromManagedObjectContext {
    
    Participant *newParticipant = [Participant participant];
    Person *newPerson = [Person person];
    [newParticipant addPersonsObject:newPerson];
    
    Contact *newContact = [Contact contact];
    newContact.person = newPerson;
    Event *newEvent = [Event event];
    [newContact addEventsObject:newEvent];
    
    NSError *saveError = nil;
    [newContact.managedObjectContext save:&saveError];
    
    STAssertNil(saveError, [NSString stringWithFormat:@"Didn't save… %@", saveError]);
    
    NSManagedObjectContext *currentContext = newContact.managedObjectContext;
    NSManagedObjectID *contactID = newContact.objectID;
    STAssertFalse(contactID.isTemporaryID, @"ID ");
    [newContact deleteFromManagedObjectContext:currentContext];
    
    STAssertNil([Contact findByPrimaryKey:contactID], @"Contact was found");
    
}

@end
