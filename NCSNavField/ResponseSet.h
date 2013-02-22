//
//  ResponseSet.h
//  NCSNavField
//
//  Created by John Dzak on 9/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUResponseSet.h"

@class NUSurvey;

@interface ResponseSet : NUResponseSet

@property(nonatomic,strong) NSString* survey;

+ (ResponseSet*)createResponseSetWithSurvey:(NUSurvey*)survey pId:(NSString*)pId personId:(NSString*)personId;

@end
