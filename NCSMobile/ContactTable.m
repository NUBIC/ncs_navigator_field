//
//  ContactPresenter.m
//  NCSMobile
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
#import "Address.h"
#import "Location.h"
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
    return [NSArray arrayWithObjects: 
                [self addresses], 
                [self phones], 
                [self emails],
                [self contactDetails],
                nil];
}

- (Section*) addresses {
    Row *home = [[Row alloc] initWithText:@"Home"];
    
    Address *a = _contact.location.address;
    home.detailText = [NSString stringWithFormat:@"%@\n%@, %@ %@", a.street, a.city, a.state, a.zipCode];
    
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
    Row *r = [[Row new] autorelease];
      
    if (_contact.closed) {
        r.text = @"Modify Closed Contact";
    } else if (_contact.initiated) {
        r.text = @"Continue Contact";
    } else {
        r.text = @"Start Contact";
    }
    
    NSArray* eventNames = [[_contact.events allObjects] valueForKey:@"name"];
    NSString* eventsText = [eventNames componentsJoinedByString:@" and "];
    r.detailText = eventsText;
    r.rowClass = @"contact";
    r.entity = _contact;
    [s addRow:r];
    return s;
}

- (void) dealloc {
    [_contact release];
    [_sections release];
    [super dealloc];
}

@end
