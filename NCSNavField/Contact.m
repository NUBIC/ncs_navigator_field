//
//  Contact.m
//  NCSNavField
//
//  Created by John Dzak on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"
#import "Event.h"
#import "EventTemplate.h"
#import "Person.h"
#import "Participant.h"
#import "NSString+Additions.h"
#import "NSDate+Additions.h"
#import <NUSurveyor/NUUUID.h>

@implementation Contact

@dynamic contactId, typeId, date, startTime, endTime, personId, person, initiated, events, locationId, locationOther, whoContactedId, whoContactedOther, comments, languageId, languageOther, interpreterId, interpreterOther, privateId, privateDetail, distanceTraveled, dispositionCode, version, appCreated;
@synthesize selectedValueForCategory = _selectedValueForCategory;

+ (Contact*)contact {
    Contact* c = [Contact object];
    c.contactId = [NUUUID generateUuidString];
    c.date = [NSDate date];
    c.startTime = [NSDate date];
    return c;
}

- (Person *)person {
    return [Person findFirstByAttribute:@"personId" withValue:self.personId];
}

-(void)setPerson:(Person *)person {
    NSManagedObjectContext *moc = [person managedObjectContext];
    NSError *saveError = nil;
    BOOL didSave = [moc save:&saveError];
    if (didSave == NO) {
        NSLog(@"didn't save: %@", person);
    }
}

+(NSNumber*)dispositionCodeFromContactTypeId:(NSNumber*)typeId {
    if([typeId isEqualToNumber:[NSNumber numberWithInt:1]]) {
        return [NSNumber numberWithInt:3];
    }
    else if([typeId isEqualToNumber:[NSNumber numberWithInt:2]]) {
        return [NSNumber numberWithInt:4];
    }
    else {
        return [NSNumber numberWithInt:5];
    }
}

-(void) generateEventWithName:(NSString *)eventTemplateName {
    Participant* participant = [Participant participant];
    Person* person = [participant selfPerson];
    self.person = person;
    self.personId = person.personId;
    
    EventTemplate* pregnancyScreeningEventTmpl = nil; 
    if ([eventTemplateName isEqualToString:EVENT_TEMPLATE_PBS_ELIGIBILITY] || [eventTemplateName isEqualToString:EVENT_TEMPLATE_PBS_ELIGIBILITY_LEGACY]) {
        pregnancyScreeningEventTmpl = [EventTemplate pregnancyScreeningTemplate];
        participant.typeCode = PARTICIPANT_TYPE_PBS_SCREENING;
    }
    else if ([eventTemplateName isEqualToString:EVENT_TEMPLATE_BIRTH_COHORT]) {
        pregnancyScreeningEventTmpl = [EventTemplate birthCohortTemplate];
        participant.typeCode = PARTICIPANT_TYPE_BIRTH_COHORT;
    }
    
    if (pregnancyScreeningEventTmpl) {
        [self addEventsObject:[pregnancyScreeningEventTmpl buildEventForParticipant:participant person:person]];
    }
}

+(NSNumber*)findDispositionCode:(NSString*)str {
    
    if(([str isEqualToString:@"Text Message"])||([str isEqualToString:@"Telephone"]))
    {
        return [NSNumber numberWithInt:5];
    }
    else if([str isEqualToString:@"Website"]||([str isEqualToString:@"Email"]))
    {
        return [NSNumber numberWithInt:6];
    }
    else if([str isEqualToString:@"Mail"])
    {
        return [NSNumber numberWithInt:4];
    }
    else if([str isEqualToString:@"In person"]||([str isEqualToString:@"Other"]))
    {
        return [NSNumber numberWithInt:3];
    }
    return nil;
}

- (BOOL) closed {
    return [self.dispositionCode integerValue] != 0;
}

- (void) setStartTimeJson:(NSString*)startTime {
    self.startTime = [startTime jsonTimeToDate];
}

- (NSString*) startTimeJson {
    return [self.startTime jsonSchemaTime];
}

- (void) setEndTimeJson:(NSString*)endTime {
    self.endTime = [endTime jsonTimeToDate];
}

- (NSString*) endTimeJson {
    return [self.endTime jsonSchemaTime];
}

- (NSNumber*)dispositionCodeNumber {
    NSNumber* result = nil;
    if (self.dispositionCode) {
        NSNumberFormatter* f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        result = [f numberFromString:self.dispositionCode];
    }
    return result;
}
//Returns nil if a special event type is not found.
-(NSNumber*)whichSpecialCase {
    NSSet *eventSet = 
        [self.events objectsPassingTest:^BOOL(id obj, BOOL *stop) {
            Event *e = (Event*)obj;
            return ([e.eventTypeCode isEqualToNumber:[NSNumber numberWithInt:22]]||
             [e.eventTypeCode isEqualToNumber:[NSNumber numberWithInt:34]]);
        }];
    NSAssert([eventSet count]<2, @"Two (or more) events should not be special events (inside Contact.)");
    if([eventSet count]==1) {
        Event *e = [[eventSet allObjects] objectAtIndex:0];
        if([e.eventTypeCode isEqualToNumber:[NSNumber numberWithInt:34]])
            return [NSNumber numberWithInt:8];
        if([e.eventTypeCode isEqualToNumber:[NSNumber numberWithInt:22]])
            return [NSNumber numberWithInt:7];

    }
    return nil;
}

-(BOOL)onSameDay:(Contact*)c {
    
    NSDate *myDate,*yourDate;
    NSDateComponents *myComponents,*yourComponents;
    myDate = self.date;
    yourDate = c.date;
    //Check for nils
    if(!myDate || !yourDate) //If either is nil, then obviously they don't match. 
        return FALSE;
    NSCalendar *cal = [NSCalendar currentCalendar];
    myComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:myDate];
    yourComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:yourDate];
    if((myComponents.month == yourComponents.month)&&([myComponents year]==[yourComponents year])&&([myComponents day]==[yourComponents day]))
    {
        return TRUE;
    }
    return FALSE;
}

-(BOOL)deleteFromManagedObjectContext:(NSManagedObjectContext *)context {
    
    Person *selectedPerson = self.person;
    Participant *selectedParticipant = selectedPerson.participant;
    [context deleteObject:selectedParticipant];
    [context deleteObject:self];
    NSError *saveError = nil;
    if ([context save:&saveError] == YES)
        return YES;
    else {
        NSLog(@"There was a problem deleting contact: %@ with error: %@", self, saveError);
        return NO;
    }
}

@end
