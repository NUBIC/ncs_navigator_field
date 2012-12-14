//
//  NUQuestion.h
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUQuestion : NSObject {
    NSDictionary* _questionDictionary;
}

@property(nonatomic,retain)NSDictionary* questionDictionary;

- (id)initWithQuestionDictionary:dQuestion;

@end
