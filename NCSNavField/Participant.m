//
//  Participant.m
//  NCSNavField
//
//  Created by John Dzak on 11/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "Participant.h"
#import "Person.h"
#import "HumanReadablePublicIdGenerator.h"
#import <MRCEnumerable/MRCEnumerable.h>

@implementation Participant

@dynamic pId;
@dynamic persons;
@dynamic typeCode;


+ (Participant*)participant {
    Participant* p = [Participant object];
    p.pId = [HumanReadablePublicIdGenerator generate];
    [p addPersonsObject:[Person person]];
    return p;
}

// Person record for this participant
- (Person*)selfPerson {
    return [self.persons detect:^BOOL(id obj) {
        Person* p = (Person*) obj;
        return [p isPersonSameAsParticipant];
    }];
}

@end
