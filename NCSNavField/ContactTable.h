//
//  ContactPresenter.h
//  NCSNavField
//
//  Created by John Dzak on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISimpleTable.h"

@class Contact;
@class Section;
@class Event;

@interface ContactTable : NSObject<ISimpleTable> {
    @private
    Contact *_contact;
    NSArray *_sections;
}

@property(nonatomic,strong) NSArray* sections;
@property(nonatomic,strong) Contact* contact;

- (id)initUsingContact:(Contact*)contact;
- (NSArray*) buildSectionsFromContact:(Contact*)contact;
- (Section*) addresses;
- (Section*) phones;
- (Section*) emails;
- (Section*) contactDetails;
- (Section*) scheduledInstruments;
- (Section*) scheduledEvents;
- (NSArray*) sortedEvents;

- (NSString*) ReplaceFirstNewLine:(NSString*) original;
- (NSArray*) rejectEmptySections:(NSArray*)raw;

@end
