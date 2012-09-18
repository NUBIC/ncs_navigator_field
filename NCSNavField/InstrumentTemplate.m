//
//  InstrumentTemplate.m
//  NCSNavField
//
//  Created by John Dzak on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InstrumentTemplate.h"
#import <SBJSON.h>

@implementation InstrumentTemplate
@dynamic instrumentTemplateId,representation,participantType;

- (void)setRepresentationDictionary:(NSDictionary*)r {
    self.representation = [[[[SBJSON alloc] init] autorelease] stringWithObject:r];
}

- (NSDictionary*)representationDictionary {
    return [[[[SBJSON alloc] init] autorelease] objectWithString:self.representation];
}

@end
