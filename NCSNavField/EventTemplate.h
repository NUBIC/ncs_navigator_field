//
//  EventTemplate.h
//  NCSNavField
//
//  Created by John Dzak on 10/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Instrument;
@class Event;

@interface EventTemplate : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * eventRepeatKey;
@property (nonatomic, retain) NSNumber * eventTypeCode;
@property (nonatomic, retain) NSOrderedSet *instruments;

#pragma mark - Methods

+ (EventTemplate*)pregnancyScreeningTemplate;

- (Event*)buildEvent;

@end

@interface EventTemplate (CoreDataGeneratedAccessors)

- (void)insertObject:(Instrument *)value inInstrumentsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromInstrumentsAtIndex:(NSUInteger)idx;
- (void)insertInstruments:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeInstrumentsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInInstrumentsAtIndex:(NSUInteger)idx withObject:(Instrument *)alue;
- (void)replaceInstrumentsAtIndexes:(NSIndexSet *)indexes withInstruments:(NSArray *)alues;
- (void)addInstrumentsObject:(Instrument *)value;
- (void)removeInstrumentsObject:(Instrument *)value;

- (void)addInstruments:(NSOrderedSet *)values;
- (void)removeInstruments:(NSOrderedSet *)values;

@end
