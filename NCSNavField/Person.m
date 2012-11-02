//
//  Person.m
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@implementation Person

static const NSString* NEW_PERSON_NAME = @"New Person";

@dynamic personId, name, email, homePhone, cellPhone, street, city, zipCode, state, participant;

+ (Person*)person {
    Person* p = [Person object];
    p.name = [self buildNewPersonName];
    return p;
}

+ (NSString*)buildNewPersonName {
    NSInteger count = [self newPersonCount];
    return [NSString stringWithFormat:@"%@ #%d", NEW_PERSON_NAME, count + 1];
}

+ (NSInteger)newPersonCount {
    NSPredicate* p = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", NEW_PERSON_NAME];
    return [[Person findAllWithPredicate:p] count];
}

@end
