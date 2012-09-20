//
//  NUMultiSurveyTVC.h
//  NCSNavField
//
//  Created by John Dzak on 9/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSurveyTVC.h"

@interface MultiSurveyTVC : NUSurveyTVC {
    NSArray* _surveys;
    NSDictionary* _surveyResponseSetAssociations;
    NSInteger _activeSurveyIndex;
}

@property(nonatomic,retain) NSArray* surveys;

@property(nonatomic,retain) NSDictionary* surveyResponseSetAssociations;

@property(nonatomic) NSInteger activeSurveyIndex;

- (id)initWithSurveys:(NSArray*)surveys surveyResponseSetAssociations:(NSDictionary *)surveyResponseSetAssociations;

- (void)setActiveSurvey:(NSInteger)index;

@end
