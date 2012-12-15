//
//  SurveyResponseSetRelationship.h
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NUSurvey, ResponseSet;

@interface SurveyResponseSetRelationship : NSObject {
    NUSurvey* _survey;
    ResponseSet* _responseSet;
}

@property(nonatomic,retain) NUSurvey* survey;

@property(nonatomic,retain) ResponseSet* responseSet;

- (id)initWithSurvey:(NUSurvey*)survey responseSet:(ResponseSet*)responseSet;

@end
