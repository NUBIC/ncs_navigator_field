//
//  FieldWork.m
//  NCSNavField
//
//  Created by John Dzak on 3/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "Fieldwork.h"

@implementation Fieldwork

@synthesize fieldworkId;

@dynamic uri, retrievedDate, participants, contacts, instrumentTemplates;

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

+ (Fieldwork*)fieldworkNeededToBeSubmitted {
    Fieldwork* f = [[Fieldwork findAllSortedBy:@"retrievedDate" ascending:YES] lastObject];
    return [f.contacts count] > 0 ? f : nil;
}

@end
