//
//  SurveySeries.m
//  NCSNavField
//
//  Created by John Dzak on 10/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "SurveySet.h"
#import "ResponseSet.h"
#import "Participant.h"
#import <MRCEnumerable/MRCEnumerable.h>
#import <NUSurveyor/NUSurvey.h>
#import "NUSurvey+Additions.h"
#import <NUSurveyor/NUResponseSet.h>
#import <NUSurveyor/NUResponse.h>
#import "NUResponse+Additions.h"

@implementation SurveySet

@synthesize surveys = _surveys;
@synthesize responseSets = _responseSets;

- (id)initWithSurveys:(NSArray*)s andResponseSets:(NSArray*)rs {
    if (self = [self init]) {
        _surveys = s;
        _responseSets = rs;        
    }
    return self;
}

- (NSDictionary*)sectionforSurveyIndex:(NSInteger)sui sectionIndex:(NSInteger)sei {
    NSDictionary* found = nil;
    
    if (sui < [self.surveys count]) {
        NUSurvey* su = [self.surveys objectAtIndex:sui];
        if (su) {
            NSArray* secs = [[su deserialized] objectForKey:@"sections"];
            if (sei < [secs count]) {
                found = [secs objectAtIndex:sei];
            }
        }
    }
    
    return found;
}

- (NSDictionary*)previousSectionfromSurveyIndex:(NSInteger)sui sectionIndex:(NSInteger)sei {
    if (sui<= 0 && sei <= 0) {
        return nil;
    }
    
    NSDictionary* found = [self sectionforSurveyIndex:sui sectionIndex:sei - 1];
    
    if (!found) {
        NUSurvey* psu = [self.surveys objectAtIndex:sui - 1];
        if (psu) {
            NSDictionary* psecs = [[psu deserialized] objectForKey:@"sections"];
            if (psecs) {
                found = [self sectionforSurveyIndex:sui - 1 sectionIndex:[psecs count] - 1];
            }
        }
    }
    
    return found;
}

- (NSDictionary*)nextSectionfromSurveyIndex:(NSInteger)sui sectionIndex:(NSInteger)sei {
    NSDictionary* found = [self sectionforSurveyIndex:sui sectionIndex:sei + 1];
    
    if (!found) {
        found = [self sectionforSurveyIndex:sui + 1 sectionIndex:0];
    }

    return found;
}

@end
