//
//  SurveySeries.h
//  NCSNavField
//
//  Created by John Dzak on 10/1/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResponseSet;
@class Participant;
@class NUSurvey;

@interface SurveySet : NSObject {
    NSArray* _surveys;
}

@property(nonatomic,strong) NSArray* surveys;

#pragma mark - Instance Methods

- (id)initWithSurveys:(NSArray*)s;

- (NSDictionary*)sectionforSurveyIndex:(NSInteger)sui sectionIndex:(NSInteger)sei;

- (NSDictionary*)previousSectionfromSurveyIndex:(NSInteger)sui sectionIndex:(NSInteger)sei;

- (NSDictionary*)nextSectionfromSurveyIndex:(NSInteger)sui sectionIndex:(NSInteger)sei;

@end
