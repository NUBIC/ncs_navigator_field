//
//  NUMultiSurveyTVC.h
//  NCSNavField
//
//  Created by John Dzak on 9/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSurveyTVC.h"
#import "UIView+Additions.h"

@interface MultiSurveyTVC : NUSurveyTVC {
    NSArray* _surveyResponseSetAssociations;
    NSInteger _activeSurveyIndex;
}

@property(nonatomic,strong) NSArray* surveyResponseSetAssociations;

@property(nonatomic) NSInteger activeSurveyIndex;

- (id)initWithSurveyResponseSetRelationships:(NSArray*)rels;

@end
