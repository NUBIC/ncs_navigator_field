//
//  NUAnswer.m
//  NCSNavField
//
//  Created by John Dzak on 1/31/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUAnswer.h"
#import "NUQuestion.h"
#import "NSManagedObject+Additions.h"

@implementation NUAnswer

@dynamic uuid;
@dynamic referenceIdentifier;
@dynamic type;
@dynamic question;

+ (NUAnswer*)transientWithDictionary:(NSDictionary*)dict {
    NUAnswer* created = [[self class] transient];
    if (created) {
        created.uuid = [dict valueForKey:@"uuid"];
        created.referenceIdentifier = [dict valueForKey:@"reference_identifier"];
        created.type = [dict valueForKey:@"type"];
    }
    return created;
}

@end
