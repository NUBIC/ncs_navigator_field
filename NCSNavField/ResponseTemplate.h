//
//  ResponseTemplate.h
//  NCSNavField
//
//  Created by John Dzak on 12/13/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NUSurvey;
@class NUQuestion;
@class NUAnswer;

@interface ResponseTemplate : NSManagedObject

@property (nonatomic, retain) NSString * qref;
@property (nonatomic, retain) NSString * aref;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * surveyId;
@property (nonatomic, retain) NUSurvey * cachedSurvey;
@property (nonatomic, retain) NUQuestion * cachedQuestion;
@property (nonatomic, retain) NUAnswer * cachedAnswer;

- (NUSurvey*)survey;

- (NUQuestion*)question;

- (NUAnswer*)answer;

@end
