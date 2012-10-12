//
//  InstrumentPlan.h
//  NCSNavField
//
//  Created by Dzak, John J on 9/7/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InstrumentTemplate;

@interface InstrumentPlan : NSManagedObject

@property (nonatomic, strong) NSString * instrumentPlanId;
@property (nonatomic, strong) NSOrderedSet *instrumentTemplates;
@end

@interface InstrumentPlan (CoreDataGeneratedAccessors)

- (void)insertObject:(InstrumentTemplate *)value inInstrumentTemplatesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromInstrumentTemplatesAtIndex:(NSUInteger)idx;
- (void)insertInstrumentTemplates:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeInstrumentTemplatesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInInstrumentTemplatesAtIndex:(NSUInteger)idx withObject:(InstrumentTemplate *)value;
- (void)replaceInstrumentTemplatesAtIndexes:(NSIndexSet *)indexes withInstrumentTemplates:(NSArray *)values;
- (void)addInstrumentTemplatesObject:(InstrumentTemplate *)value;
- (void)removeInstrumentTemplatesObject:(InstrumentTemplate *)value;
- (void)addInstrumentTemplates:(NSOrderedSet *)values;
- (void)removeInstrumentTemplates:(NSOrderedSet *)values;
@end
