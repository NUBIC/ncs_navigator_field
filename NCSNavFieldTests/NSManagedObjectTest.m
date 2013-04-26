//
//  NSManagedObjectTest.m
//  NCSNavField
//
//  Created by John Dzak on 11/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NSManagedObjectTest.h"
#import "NSManagedObject+Additions.h"
#import "Contact.h"
#import "Event.h"
#import "Participant.h"
#import "InstrumentPlan.h"
#import "InstrumentTemplate.h"
#import "Person.h"
#import "NUQuestion.h"

@implementation NSManagedObjectTest

- (void)testClone {
    Contact* base = [Contact object];
    base.comments = @"Up and atom";
    Contact* cloned = (Contact*) [base cloneAndignoreRelations:nil];
    STAssertTrue(base.objectID != cloned.objectID, nil);
    STAssertEqualObjects(cloned.comments, @"Up and atom", nil);
}

- (void)testCloneWithUnorderedHasManyRelationship {
    Contact* base = [Contact object];
    Event* baseEvent = [Event object];
    baseEvent.name = @"The goggles";
    [base addEventsObject:baseEvent];
    Contact* cloned = (Contact*) [base cloneAndignoreRelations:nil];
    STAssertEquals([cloned.events count], 1U, nil);
    Event* clonedEvent = [cloned.events anyObject];
    STAssertTrue(baseEvent.objectID != clonedEvent.objectID, nil);
    STAssertEqualObjects(clonedEvent.name, @"The goggles", nil);
}

- (void)testCloneWithOrderedHasManyRelationship {
    InstrumentPlan* base = [InstrumentPlan object];
    InstrumentTemplate* baseIT = [InstrumentTemplate object];
    baseIT.participantType = @"Quack";
    [base setInstrumentTemplates:[NSOrderedSet orderedSetWithObject:baseIT]];  //addInstrumentTemplatesObject fails with sigtrap
    InstrumentPlan* cloned = (InstrumentPlan*) [base cloneAndignoreRelations:nil];
    STAssertEquals([cloned.instrumentTemplates count], 1U, nil);
    InstrumentTemplate* clonedIT = [cloned.instrumentTemplates firstObject];
    STAssertTrue(baseIT.objectID != clonedIT.objectID, nil);
    STAssertEqualObjects(clonedIT.participantType, @"Quack", nil);
}

- (void)testCloneWithHasOne {
    Person *person = [Person object];
    Participant *participant = [Participant object];
    participant.pId = @"pid";
    person.participant = participant;
    Person *clonedPerson = (Person *)[person cloneAndignoreRelations:nil];
    STAssertFalse([participant.objectID isEqual:clonedPerson.participant.objectID], @"person's participant did not clone correctly.");
    STAssertTrue([participant.pId isEqualToString:clonedPerson.participant.pId], @"participant name did not clone correctly.");
}

- (void)testCloneIntoManagedObjectContext {
    NUQuestion* base = [NUQuestion transient];
    base.uuid = @"Zebra";
    NUQuestion* cloned = (NUQuestion*)[base cloneIntoManagedObjectContext:[self managedObjectContext]];
    STAssertEqualObjects(cloned.uuid, @"Zebra", nil);
    STAssertEqualObjects([self managedObjectContext], cloned.managedObjectContext, nil);
}

- (void)testTransient {
    STAssertNil([[NUQuestion transient] managedObjectContext], nil);
}

- (void)testIsTransient {
    STAssertTrue([[NUQuestion transient] isTransient], nil);
}

@end
