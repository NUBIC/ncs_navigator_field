//
//  NUQuestionGroup.h
//  NCSNavField
//
//  Created by John Dzak on 1/17/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUQuestionGroup : NSObject

@property(nonatomic,retain) NSArray* questions;

- (id)initWithDictionary:(NSDictionary*)questionGroupDict;

+ (BOOL)isQuestionGroupDict:(NSDictionary*)dict;

@end
