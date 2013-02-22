//
//  NUQuestion.h
//  NCSNavField
//
//  Created by John Dzak on 1/31/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NUAnswer, InstrumentTemplate;

@interface NUQuestion : NSManagedObject

@property (nonatomic, retain) NSString * referenceIdentifier;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) InstrumentTemplate * instrumentTemplate;
@property (nonatomic, retain) NSOrderedSet *answers;

#pragma mark - Class Methods

+ (NUQuestion*)transientWithDictionary:(NSDictionary*)dict;

#pragma mark - Instance Methods

- (NUQuestion*)persist;

- (NSString*)referenceIdentifierWithoutHelperPrefix;

- (BOOL)isHelperQuestion;

@end

@interface NUQuestion (CoreDataGeneratedAccessors)

- (void)insertObject:(NUAnswer *)value inAnswersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAnswersAtIndex:(NSUInteger)idx;
- (void)insertAnswers:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAnswersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAnswersAtIndex:(NSUInteger)idx withObject:(NUAnswer *)value;
- (void)replaceAnswersAtIndexes:(NSIndexSet *)indexes withAnswers:(NSArray *)values;
- (void)addAnswersObject:(NUAnswer *)value;
- (void)removeAnswersObject:(NUAnswer *)value;
- (void)addAnswers:(NSOrderedSet *)values;
- (void)removeAnswers:(NSOrderedSet *)values;
@end
