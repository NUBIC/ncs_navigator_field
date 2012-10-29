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

@interface EventTemplate : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * eventRepeatKey;
@property (nonatomic, retain) NSNumber * eventTypeCode;
@property (nonatomic, retain) NSSet *instruments;
@end

@interface EventTemplate (CoreDataGeneratedAccessors)

- (void)addInstrumentsObject:(Instrument *)value;
- (void)removeInstrumentsObject:(Instrument *)value;
- (void)addInstruments:(NSSet *)values;
- (void)removeInstruments:(NSSet *)values;

@end
