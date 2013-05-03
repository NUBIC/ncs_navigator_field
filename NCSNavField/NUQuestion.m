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
#import "InstrumentTemplate.h"

@implementation NUQuestion

@dynamic answers, instrumentTemplate, referenceIdentifier, uuid, text, translation;

static NSString *HELPER_QUESTION_REFERENCE_IDENTIFIER_PREFIX = @"helper_";

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

- (NUQuestion*)persist {
    if (self.isTransient) {
        return (NUQuestion*)[self cloneIntoManagedObjectContext:[NSManagedObjectContext contextForCurrentThread] ignoreRelations:@[@"instrumentTemplate"]];
    }
    return self;
}

- (NSString*)referenceIdentifierWithoutHelperPrefix {
    return [self.referenceIdentifier stringByReplacingOccurrencesOfString:HELPER_QUESTION_REFERENCE_IDENTIFIER_PREFIX withString:@"" options:NSCaseInsensitiveSearch | NSAnchoredSearch range:NSMakeRange(0, [self.referenceIdentifier length])];
}

- (BOOL)isHelperQuestion {
    return [self.referenceIdentifier rangeOfString:HELPER_QUESTION_REFERENCE_IDENTIFIER_PREFIX options:NSCaseInsensitiveSearch | NSAnchoredSearch].location != NSNotFound;
}

// BUG: This is a workaround for a bug when using the generated method
//      addInstrumentsObject to add an instrument to the ordered set.
//      https://openradar.appspot.com/10114310
- (void)addAnswersObject:(NUAnswer *)value {
    NSMutableOrderedSet *temporaryAnswers = [self.answers mutableCopy];
    [temporaryAnswers addObject:value];
    self.answers = [NSOrderedSet orderedSetWithOrderedSet:temporaryAnswers];
}

@end
