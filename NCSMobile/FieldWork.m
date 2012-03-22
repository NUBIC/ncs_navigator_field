//
//  FieldWork.m
//  NCSMobile
//
//  Created by John Dzak on 3/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldWork.h"

@implementation FieldWork

@synthesize fieldWorkId;

@dynamic uri, retrievedDate, participants, contacts, instrumentTemplates;

- (NSString*)fieldWorkId {
    NSString* ident = NULL;
    if (self.uri) {
        NSString* rel = [[[NSURL alloc] initWithString:self.uri] relativePath];
        ident = [[rel componentsSeparatedByString:@"/"] lastObject];
    }
    return ident;
}

// TODO: This is a workaround for a problem caused when calling 
- (BOOL)isNew {
    return false;
}

@end
