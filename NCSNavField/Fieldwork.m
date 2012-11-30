//
//  FieldWork.m
//  NCSNavField
//
//  Created by John Dzak on 3/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "Fieldwork.h"
#import "Contact.h"
#import "Participant.h"
#import "InstrumentTemplate.h"

@implementation Fieldwork

@synthesize fieldworkId;

@dynamic uri, retrievedDate;

- (NSString*)fieldworkId {
    NSString* ident = NULL;
    if (self.uri) {
        NSString* rel = [[[NSURL alloc] initWithString:self.uri] relativePath];
        ident = [[rel componentsSeparatedByString:@"/"] lastObject];
    }
    return ident;
}

- (NSArray*) emptyArray {
    return [NSArray array];
}

+ (Fieldwork*)submission {
    Fieldwork* f = [[Fieldwork findAllSortedBy:@"retrievedDate" ascending:YES] lastObject];
    return [f.contacts count] > 0 ? f : nil;
}

- (NSArray*)contacts {
    return [Contact findAll];
}

- (NSArray*)participants {
    return [Participant findAll];
}

- (NSArray*)instrumentTemplate {
    return [InstrumentTemplate findAll];
}
//w.participants = [[NSSet alloc] initWithArray:[objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity.name like %@", [[Participant entity] name ]]]];
//w.contacts = [[NSSet alloc] initWithArray:[objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity.name like %@", [[Contact entity] name ]]]];
//w.instrumentTemplates = [[NSSet alloc] initWithArray:[objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"entity.name like %@", [[InstrumentTemplate entity] name ]]]];


@end
