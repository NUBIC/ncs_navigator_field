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

@implementation ContactTable

@synthesize sections=_sections;

- (id)initUsingContact:(Contact*)contact {
    self = [super init];
    if (self) {
        _contact = [contact retain];
        _sections = [[self buildSectionsFromContact:contact] retain];
    }
    
    return self;
}

- (NSArray*) buildSectionsFromContact:(Contact*)contact { 
    NSMutableArray* sections = [[NSMutableArray alloc] initWithCapacity:5];
    [self addSection:[self addresses] to:sections];
    [self addSection:[self phones] to:sections];
    [self addSection:[self emails] to:sections];
    [self addSection:[self contactDetails] to:sections];
    if (_contact.initiated) {
        NSArray* sorted = [[contact.events allObjects] sortedArrayUsingComparator:^(id a, id b) {
            NSDate *first = [(Event*)a startDate];
            NSDate *second = [(Event*)b startDate];
            return [first compare:second];
        }];
        for (Event* e in sorted) {
            [self addSection:[self event:e] to:sections];
        }
    }
    return sections;
}

// TODO: Figure out a better way to handle large addresses like resize cell
- (Section*) addresses {
    Row *home = [[Row alloc] initWithText:@"Home"];
    home.rowClass = @"address";
    
    Person *p = _contact.person;
    home.detailText = [NSString stringWithFormat:@"%@\n%@, %@ %@", [self ReplaceFirstNewLine:p.street], p.city, p.state, p.zipCode];
    
    return [[[Section alloc] initWithName:@"Address" andRows:home, nil] autorelease];
}

- (Section*) phones {
    Row* home = [[[Row alloc] initWithText:@"Home" detailText:_contact.person.homePhone] autorelease];
    Row* cell = [[[Row alloc] initWithText:@"Cell" detailText:_contact.person.cellPhone] autorelease];
    
    return [[[Section alloc] initWithName:@"Phone" andRows:home, cell, nil] autorelease];
}

- (Section*) emails {
    Row* home =[[Row alloc] initWithText:@"Home" detailText:_contact.person.email];
    return [[[Section alloc] initWithName:@"Email" andRows:home, nil] autorelease];
}


- (Section*) contactDetails {
    Section *s = [[Section new] autorelease];
    s.name = @"Contact";
    
    NSArray* eventNames = [[_contact.events allObjects] valueForKey:@"name"];
    NSString* eventsText = [eventNames componentsJoinedByString:@" and "];
    
    Row *r = [[Row new] autorelease];
    
    if (_contact.closed) {
        r.text = [NSString stringWithFormat:@"Modify Closed Contact %@", eventsText];
    } else if (_contact.initiated) {
        r.text = [NSString stringWithFormat:@"Continue Contact for %@", eventsText];
    } else {
        r.text = [NSString stringWithFormat:@"Start Contact for %@", eventsText];
    }
    r.rowClass = @"contact";
    r.entity = _contact;
    [s addRow:r];
    return s;
}

- (Section*)event:(Event*)e {
    Section* s = [Section new];
    s.name = @"Scheduled Activities";
    for (Instrument* i in e.instruments) {
        Row* r0 = [[Row new] autorelease];
        r0.text = [NSString stringWithFormat:@"%@ %@", e.name, @"Instrument"];
        r0.rowClass = @"instrument";
        r0.entity = i;
        [s addRow:r0];
        Row* r1 = [[Row new] autorelease];
        r1.text = [NSString stringWithFormat:@"%@ Activity Details", e.name];
        r1.rowClass = @"instrument-details";
        r1.entity = i;
        [s addRow:r1];
    }
    
    return s;
}

- (void)addSection:(Section*)section to:(NSMutableArray*)sections{
    if (section != NULL) {
        [sections addObject:section];
    }
}


- (NSString*) ReplaceFirstNewLine:(NSString*) original {
    NSMutableString * newString = [NSMutableString stringWithString:original];
    
    NSRange foundRange = [original rangeOfString:@"\n"];
    if (foundRange.location != NSNotFound)
    {
        [newString replaceCharactersInRange:foundRange
                                 withString:@""];
    }
    
    return [[newString retain] autorelease];
}


- (void) dealloc {
    [_contact release];
    [_sections release];
    [super dealloc];
}

@end
