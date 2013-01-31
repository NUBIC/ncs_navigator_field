//
//  NUQuestion.m
//  NCSNavField
//
//  Created by John Dzak on 1/31/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUQuestion.h"
#import "NUAnswer.h"
#import "NSManagedObject+Additions.h"

@implementation NUQuestion

@dynamic referenceIdentifier;
@dynamic text;
@dynamic uuid;
@dynamic answers;

+ (NUQuestion*)transientWithDictionary:(NSDictionary*)dict {
    NUQuestion* created = [self transient];
    if (created) {
        created.uuid = [dict valueForKey:@"uuid"];
        created.text = [dict valueForKey:@"text"];
        created.referenceIdentifier = [dict valueForKey:@"reference_identifier"];
        for (NSDictionary* aDict in [dict objectForKey:@"answers"]) {
            NUAnswer* a = [NUAnswer transientWithDictionary:aDict];
            [created addAnswersObject:a];
        }
    }
    return created;
}

- (void)persist {
    if (self.isTransient) {
        [self cloneIntoManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]];
    }
}

@end
