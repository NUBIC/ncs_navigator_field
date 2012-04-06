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
    return [NSArray arrayWithObjects: 
                [self addresses], 
                [self phones], 
                [self emails],
                [self contactDetails],
                nil];
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
