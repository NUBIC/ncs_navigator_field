//
//  DetailViewPresenter.h
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISimpleTable.h"

@class Row;
@class Contact;

@interface ContactNavigationTable : NSObject<ISimpleTable> {
    @private
    NSArray* _sections;
}

- (ContactNavigationTable*)initWithContacts: (NSArray*)events;
- (NSArray*) buildSectionsUsingContacts:(NSArray*) contacts;
- (NSString*) buildSectionNameUsingDate:(NSDate*)date;
- (NSArray*) buildRowsUsingContacts:(NSArray*)contacts;
- (NSIndexPath*)findIndexPathForContact:(Contact*)contact;

@property(nonatomic,strong) NSArray* sections;


@end
