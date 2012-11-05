//
//  DetailViewPresenter.m
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContactNavigationTable.h"
#import "Event.h"
#import "Contact.h"
#import "Section.h"
#import "Row.h"
#import "Person.h"

@implementation ContactNavigationTable

@synthesize sections=_sections;

- (ContactNavigationTable*)initWithContacts: (NSArray*)contacts {
    self = [super init];
    if (self) {
        _sections = [self buildSectionsUsingContacts:contacts];
    }
    return self;
}

- (NSArray*) buildSectionsUsingContacts:(NSArray*) contacts {
    NSMutableArray* sections = [NSMutableArray new];
    NSSet *uniqueDates = [NSCountedSet setWithArray:[contacts valueForKey:@"date"]];
    for (NSDate *d in uniqueDates) {
        Section *s = [Section new];
        s.name = [self buildSectionNameUsingDate:d];
        
        NSPredicate *findByDate = [NSPredicate predicateWithFormat:@"date == %@", d];
        NSArray *found = [contacts filteredArrayUsingPredicate:findByDate];
        s.rows = [self buildRowsUsingContacts:found];
        
        [sections addObject:s];
    }
    return sections;
}

                  
- (NSString*) buildSectionNameUsingDate:(NSDate*)date {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"MMMM dd"];
    NSString *name = [f stringFromDate:date];
    return name;
}

- (NSArray*) buildRowsUsingContacts:(NSArray*)contacts {
    NSMutableArray *rows = [NSMutableArray new];
    for (Contact *c in contacts) {
        Row *r = [Row new];
        r.text = c.person.name ? c.person.name : @"(Person name missing)";
        r.detailText = [NSString stringWithFormat:@"%@ instruments", [NSNumber numberWithInt:[c.events count]]];
        r.entity = c;
        [rows addObject:r];
    }
    return rows;
}

- (NSIndexPath*)findIndexPathForContact:(Contact*)contact {
    NSIndexPath* result = nil;
    for (Section* s in self.sections) {
        for (Row* r in s.rows) {
            if (r.entity == contact) {
                NSInteger sIndex = [self.sections indexOfObject:s];
                NSInteger rIndex = [s.rows indexOfObject:r];
                result = [NSIndexPath indexPathForRow:rIndex inSection:sIndex];
            }
        }
    }
    return result;
}


@end
