//
//  InstrumentTemplate.m
//  NCSNavField
//
//  Created by John Dzak on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InstrumentTemplate.h"
#import <NUSurveyor/NUSurvey.h>
#import <JSONKit/JSONKit.h>

@implementation InstrumentTemplate
@dynamic instrumentTemplateId,representation,participantType;

- (void)setRepresentationDictionary:(NSDictionary*)r {
    self.representation = [r JSONString];
}

- (NSDictionary*)representationDictionary {
    return [self.representation objectFromJSONString];
}

- (NUSurvey*)survey {
    NUSurvey* s = [NUSurvey new];
    s.jsonString = self.representation;
    return s;
}

@end
