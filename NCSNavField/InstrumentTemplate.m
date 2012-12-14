//
//  InstrumentTemplate.m
//  NCSNavField
//
//  Created by John Dzak on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InstrumentTemplate.h"
#import <NUSurveyor/NUSurvey.h>
#import <SBJSON.h>

@implementation InstrumentTemplate
@dynamic instrumentTemplateId,representation,participantType;

- (void)setRepresentationDictionary:(NSDictionary*)r {
    self.representation = [[[SBJSON alloc] init] stringWithObject:r];
}

- (NSDictionary*)representationDictionary {
    return [[[SBJSON alloc] init] objectWithString:self.representation];
}

- (NUSurvey*)survey {
    NUSurvey* s = [NUSurvey new];
    s.jsonString = self.representation;
    return s;
}

@end
