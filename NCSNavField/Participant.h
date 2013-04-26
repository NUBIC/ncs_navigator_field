//
//  Participant.h
//  NCSNavField
//
//  Created by John Dzak on 11/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

FOUNDATION_EXPORT NSNumber * PARTICIPANT_TYPE_PBS_SCREENING;
FOUNDATION_EXPORT NSNumber * PARTICIPANT_TYPE_BIRTH_COHORT;

@class Fieldwork, Person;

@interface Participant : NSManagedObject

@property (nonatomic, retain) NSString * pId;
@property (nonatomic, assign) NSNumber * typeCode;
@property (nonatomic, retain) NSSet *persons;

+ (Participant*)participant;

- (Person*)selfPerson;

@end

@interface Participant (CoreDataGeneratedAccessors)

- (void)addPersonsObject:(Person *)value;
- (void)removePersonsObject:(Person *)value;
- (void)addPersons:(NSSet *)values;
- (void)removePersons:(NSSet *)values;

@end
