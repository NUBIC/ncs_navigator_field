//
//  InstrumentTemplate.h
//  NCSNavField
//
//  Created by John Dzak on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NUSurvey;
@class NUQuestion;

@interface InstrumentTemplate : NSManagedObject

@property(nonatomic,strong) NSString* instrumentTemplateId;
@property(nonatomic,strong) NSString* representation;
@property(nonatomic,strong) NSString* participantType;
@property(nonatomic,strong) NSOrderedSet *questions;

- (void)setRepresentationDictionary:(NSDictionary*)dict;

- (NSDictionary*)representationDictionary;

- (NUSurvey*)survey;

- (void)refreshQuestionsFromSurvey;

@end


@interface InstrumentTemplate (CoreDataGeneratedAccessors)

- (void)insertObject:(NUQuestion *)value inQuestionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromQuestionsAtIndex:(NSUInteger)idx;
- (void)insertQuestions:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeQuestionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInQuestionsAtIndex:(NSUInteger)idx withObject:(NUQuestion *)value;
- (void)replaceQuestionsAtIndexes:(NSIndexSet *)indexes withQuestions:(NSArray *)values;
- (void)addQuestionsObject:(NUQuestion *)value;
- (void)removeQuestionsObject:(NUQuestion *)value;
- (void)addQuestions:(NSOrderedSet *)values;
- (void)removeQuestions:(NSOrderedSet *)values;
@end
