//
//  Instrument.m
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Instrument.h"
#import "SBJSON.h"
#import "NSDate+Additions.h"
#import "NSString+Additions.h"
#import "ResponseSet.h"
#import "InstrumentPlan.h"
#import "InstrumentTemplate.h"

@implementation Instrument

@dynamic instrumentId, name, event, instrumentTypeId, instrumentTypeOther,
    instrumentVersion, repeatKey, startDate, startTime, endDate, endTime,
    statusId, breakOffId, instrumentModeId, instrumentModeOther,
    instrumentMethodId, supervisorReviewId, dataProblemId, comment, responseSets, instrumentPlanId;

- (NSArray*) responseSetDicts {
    NSMutableArray* all = [[NSMutableArray alloc] init];
    for (ResponseSet* rs in self.responseSets) {
        NSDictionary* d = rs.toDict;
        [all addObject:d];
    }
    return all;
}

- (void) setResponseSetDicts:(NSArray*)responseSetDicts {
    NSMutableSet* all = [[NSMutableSet alloc] init];
    for (NSDictionary* rsDict in responseSetDicts) {
        ResponseSet* rs = [ResponseSet object];
        [rs fromJson:[[[SBJSON alloc] init] stringWithObject:rsDict]];
        [all addObject:rs];
    }
    self.responseSets = all;
}

- (void) setStartTimeJson:(NSString*)startTime {
    self.startTime = [startTime jsonTimeToDate];
}


- (NSString*) startTimeJson {
    return [self.startTime jsonSchemaTime];
}

- (void) setEndTimeJson:(NSString*)endTime {
    self.endTime = [endTime jsonTimeToDate];
}

- (NSString*) endTimeJson {
    return [self.endTime jsonSchemaTime];
}

- (InstrumentPlan*)instrumentPlan {
    return [InstrumentPlan findFirstByAttribute:@"instrumentPlanId" withValue:self.instrumentPlanId];
}

- (NSString*)determineInstrumentVersionFromSurveyTitle {
    NSString* version = nil;
    
    InstrumentPlan* ip = [self instrumentPlan];
    if (ip) {
        InstrumentTemplate* first = [ip.instrumentTemplates firstObject];
        if (first) {
            NSDictionary* survey = [first representationDictionary];
            NSString* title = [survey valueForKey:@"title"];
            if (title) {
                NSRegularExpression *regex =
                    [NSRegularExpression regularExpressionWithPattern:@"V(\\d+(\\.\\d)?)$" options:NSRegularExpressionCaseInsensitive error:nil];
                
                NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:title
                                                                     options:0
                                                                       range:NSMakeRange(0, [title length])];
                if (!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0))) {
                    // Move range up 1 to ignore 'V'
                    NSRange range = NSMakeRange(rangeOfFirstMatch.location + 1, rangeOfFirstMatch.length - 1);
                    version = [title substringWithRange:range];
                }
            }
        }
    }
    return version;
}

- (NSString*)determineInstrumentVersion {
    return self.instrumentVersion ? self.instrumentVersion : self.determineInstrumentVersionFromSurveyTitle;
}

@end
