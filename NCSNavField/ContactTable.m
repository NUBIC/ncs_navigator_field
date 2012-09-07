//
//  ContactPresenter.m
//  NCSNavField
//
//  Created by John Dzak on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactTable.h"
#import "Contact.h"
#import "Section.h"
#import "Row.h"
#import "Person.h"
#import "Event.h"
#import "Instrument.h"
#import "NSStringHelper.h"

@implementation ContactTable

@synthesize sections=_sections;
@synthesize contact=_contact;

- (id)initUsingContact:(Contact*)contact {
    self = [super init];
    if (self) {
        _contact = [[contact retain] autorelease];
        _sections = [[self buildSectionsFromContact:contact] retain];
    }
    
    return self;
}

- (NSArray*) buildSectionsFromContact:(Contact*)contact { 
    NSMutableArray* s = [NSMutableArray arrayWithObjects:
        [self addresses], [self emails], [self contactDetails], nil];
    if (_contact.initiated) {
        [s addObject:[self scheduledInstruments]];
        [s addObject:[self scheduledEvents]];
    }
    return [self rejectEmptySections:s];
}

// TODO: Figure out a better way to handle large addresses like resize cell
- (Section*) addresses {
    NSMutableArray* addresses = [[NSMutableArray new] autorelease];

    if (self.contact.person) {
        Row *home = [[[Row alloc] 
                     initWithText:@"Home" entity:_contact.person rowClass:@"address"] autorelease];

        Person *p = _contact.person;
        home.detailText = [NSString stringWithFormat:@"%@\n%@, %@ %@", [self ReplaceFirstNewLine:p.street], p.city, p.state, p.zipCode];
        [addresses addObject:home];
    }

    return [[[Section alloc] initWithName:@"Address" andRows:addresses] autorelease];
}

- (Section*) phones {
    NSMutableArray* phones = [[[NSMutableArray alloc] init] autorelease];

    if (![NSStringHelper isEmpty:_contact.person.homePhone]) {
        Row* home = [[[Row alloc] initWithText:@"Home" detailText:_contact.person.homePhone] autorelease];
        [phones addObject:home];
    }
    if (![NSStringHelper isEmpty:_contact.person.cellPhone]) {
        Row* cell = [[[Row alloc] initWithText:@"Cell" detailText:_contact.person.cellPhone] autorelease];
        [phones addObject:cell];
    }
    
    return [[[Section alloc] initWithName:@"Phone" andRows:phones] autorelease];
}

- (Section*) emails {
    NSMutableArray* emails = [[NSMutableArray new] autorelease];
    
    if (![NSStringHelper isEmpty:self.contact.person.email]) {
        Row* home =[[[Row alloc] initWithText:@"Home" detailText:_contact.person.email] autorelease];
        [emails addObject:home];
    }

    return [[[Section alloc] initWithName:@"Email" andRows:emails] autorelease];
}


- (Section*) contactDetails {
    NSArray* eventNames = [[_contact.events allObjects] valueForKey:@"name"];
    NSString* eventsText = [eventNames componentsJoinedByString:@" and "];
    
    NSString* txt = NULL;
    if (_contact.closed) {
        txt = [NSString stringWithFormat:@"Modify Closed Contact %@", eventsText];
    } else if (_contact.initiated) {
        txt = [NSString stringWithFormat:@"Continue Contact for %@", eventsText];
    } else {
        txt = [NSString stringWithFormat:@"Start Contact for %@", eventsText];
    }
    
    Row* c = [[[Row alloc] initWithText:txt entity:self.contact rowClass:@"contact"] autorelease];
    return [[[Section alloc] initWithName:@"Contact" andRows:[NSArray arrayWithObject:c]] autorelease];
}

- (NSArray*) sortedEvents {
    NSArray* sorted = [[self.contact.events allObjects] sortedArrayUsingComparator:^(id a, id b) {
        NSDate *first = [(Event*)a startDate];
        NSDate *second = [(Event*)b startDate];
        return [first compare:second];
    }];
    return sorted;
}

- (Section*) scheduledInstruments {
    NSMutableArray* instruments = [[NSMutableArray new] autorelease];

    for (Event* e in [self sortedEvents]) {
        for (Instrument* i in e.instruments) {
            NSString* t = [NSString stringWithFormat:@"%@ %@", i.name, @"Instrument"];
            
            Row* r = [[[Row alloc] 
                        initWithText:t entity:i rowClass:@"instrument"] autorelease];

            [instruments addObject:r];
        }
    }
    
    return [[[Section alloc] initWithName:@"Scheduled Instruments" andRows:instruments] autorelease];
}

- (Section*) scheduledEvents {
    NSMutableArray* events = [[NSMutableArray new] autorelease];

    for (Event* e in [self sortedEvents]) {
        NSString* t = [NSString stringWithFormat:@"%@ %@", e.name, @"Event"];
        Row* r = [[[Row alloc] initWithText:t entity:e rowClass:@"event"] autorelease];
        [events addObject:r];
    }
    
    return [[[Section alloc] initWithName:@"Events" andRows:events] autorelease];
}

- (NSString*) ReplaceFirstNewLine:(NSString*) original {
    NSMutableString* trim = nil;
    if (original) {
        trim = [[[NSMutableString stringWithString:original] retain ]autorelease];
        
        NSRange foundRange = [original rangeOfString:@"\n"];
        if (foundRange.location != NSNotFound)
        {
            [trim replaceCharactersInRange:foundRange
                                     withString:@""];
        }

    }
    
    return trim;
}

- (NSArray*) rejectEmptySections:(NSArray*)raw {
    NSMutableArray* f = [[NSMutableArray new] autorelease];
    for (Section* s in raw) {
        if (s && s.rows && [s.rows count] > 0) {
            [f addObject:s];
        }
    }
    return f;
}

- (void)dealloc {
    [_sections release];
    [super dealloc];
}

@end
