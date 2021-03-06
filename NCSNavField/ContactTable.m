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
#import "NSString+Additions.h"
#import "EventSorter.h"

@implementation ContactTable

@synthesize sections=_sections;
@synthesize contact=_contact;

- (id)initUsingContact:(Contact*)contact {
    self = [super init];
    if (self) {
        _contact = contact;
        _sections = [self buildSectionsFromContact:contact];
    }
    
    return self;
}

- (NSArray*) buildSectionsFromContact:(Contact*)contact { 
    NSMutableArray* s = [NSMutableArray arrayWithObjects:
        [self addresses], [self phones], [self emails], [self contactDetails], nil];
    if (_contact.initiated) {
        [s addObject:[self scheduledInstruments]];
        [s addObject:[self scheduledEvents]];
    }
    return [self rejectEmptySections:s];
}

// TODO: Figure out a better way to handle large addresses like resize cell
- (Section*) addresses {
    NSMutableArray* addresses = [NSMutableArray new];

    if (self.contact.person) {
        NSString* addr = [self.contact.person formattedAddress];
        if (addr) {
            Row *home = [[Row alloc]
                         initWithText:@"Home" entity:_contact.person rowClass:@"address"];
            
            home.detailText = addr;
            [addresses addObject:home];
        }
    }

    return [[Section alloc] initWithName:@"Address" andRows:addresses];
}

- (Section*) phones {
    NSMutableArray* phones = [[NSMutableArray alloc] init];

    if (!([_contact.person.homePhone length]==0)) {
        Row* home = [[Row alloc] initWithText:@"Home" detailText:_contact.person.homePhone];
        [phones addObject:home];
    }
    if (!([_contact.person.cellPhone length]==0)) {
        Row* cell = [[Row alloc] initWithText:@"Cell" detailText:_contact.person.cellPhone];
        [phones addObject:cell];
    }
    
    return [[Section alloc] initWithName:@"Phone" andRows:phones];
}

- (Section*) emails {
    NSMutableArray* emails = [NSMutableArray new];
    
    if (!([self.contact.person.email length]==0)) {
        Row* home =[[Row alloc] initWithText:@"Home" detailText:_contact.person.email];
        [emails addObject:home];
    }

    return [[Section alloc] initWithName:@"Email" andRows:emails];
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
    
    Row* c = [[Row alloc] initWithText:txt entity:self.contact rowClass:@"contact"];
    return [[Section alloc] initWithName:@"Contact" andRows:[NSArray arrayWithObject:c]];
}

- (NSArray*) sortedEvents {
    NSArray* sorted = [[self.contact.events allObjects] sortedArrayUsingComparator:^(id a, id b) {
        return [EventSorter compareEvent:a toEvent:b];
    }];
    return sorted;
}

- (Section*) scheduledInstruments {
    NSMutableArray* instruments = [NSMutableArray new];

    for (Event* e in [self sortedEvents]) {
        for (Instrument* i in e.instruments) {
            NSString* t = [NSString stringWithFormat:@"%@ %@", i.name, @"Instrument"];
            
            Row* r = [[Row alloc] 
                        initWithText:t entity:i rowClass:@"instrument"];

            [instruments addObject:r];
        }
    }
    
    return [[Section alloc] initWithName:@"Scheduled Instruments" andRows:instruments];
}

- (Section*) scheduledEvents {
    NSMutableArray* events = [NSMutableArray new];

    for (Event* e in [self sortedEvents]) {
        NSString* t = [NSString stringWithFormat:@"%@ %@", e.name, @"Event"];
        Row* r = [[Row alloc] initWithText:t entity:e rowClass:@"event"];
        [events addObject:r];
    }
    
    return [[Section alloc] initWithName:@"Events" andRows:events];
}

- (NSString*) ReplaceFirstNewLine:(NSString*) original {
    NSMutableString* trim = nil;
    if (original) {
        trim = [NSMutableString stringWithString:original];
        
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
    NSMutableArray* f = [NSMutableArray new];
    for (Section* s in raw) {
        if (s && s.rows && [s.rows count] > 0) {
            [f addObject:s];
        }
    }
    return f;
}

#pragma mark - Accessibility
-(BOOL)isAccessibilityElement {
    return YES;
}

-(NSString*)accessibilityLabel {
    return @"Contact Table";
}

@end
