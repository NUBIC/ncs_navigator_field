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


@implementation Participant

@dynamic pId;
@dynamic persons;


+ (Participant*)participant {
    Participant* p = [Participant object];
    p.pId = [HumanReadablePublicIdGenerator generate];
    [p addPersonsObject:[Person person]];
    return p;
}

@end
