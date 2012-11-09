//
//  ResponseGenerator.h
//  NCSNavField
//
//  Created by John Dzak on 11/8/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NUSurvey;

@interface ResponseGenerator : NSObject {
    NUSurvey* _survey;
    NSDictionary* _context;
}

#pragma mark - Properties

@property(nonatomic,retain) NUSurvey* survey;

@property(nonatomic,retain) NSDictionary* context;

#pragma mark - Instance Methods

- (id)initWithSurvey:(NUSurvey*)survey context:(NSDictionary*)context;

- (NSArray*)responses;

#pragma mark - Internal Methods

- (NSArray*)prepopulatedQuestions:(NUSurvey*)survey;

- (NSString*) parsePrepopulatedPostTextForReferenceIdentifier:(NSString*)refId;


@end
