//
//  EventTemplate.m
//  NCSNavField
//
//  Created by John Dzak on 10/29/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "EventTemplate.h"
#import "Instrument.h"
#import "Event.h"
#import "NSManagedObject+Additions.h"


@implementation EventTemplate

@dynamic name;
@dynamic eventRepeatKey;
@dynamic eventTypeCode;
@dynamic instruments;

+ (EventTemplate*)pregnancyScreeningTemplate {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@ AND name CONTAINS[c] %@", @"preg", @"screen"];
    return [EventTemplate findFirstWithPredicate:predicate];
}

- (Event*)buildEvent {
    Event* e = [Event object];
    NSArray* eventAttrs = [[[EventTemplate entityDescription] attributesByName] allKeys];
    for (NSString* attr in eventAttrs) {
        id value = [self valueForKey:attr];
        id eventHasAttribute = [[[Event entityDescription] attributesByName] objectForKey:attr];
        if (eventHasAttribute) {
            [e setValue:value forKey:attr];
        } else {
            NCSLog(@"Error: Attribute '%@' does not exist on event", attr);
        }
    }

    // BUG: This is a workaround for a bug when using the generated method
    //      addInstrumentsObject to add an instrument to the ordered set.
    //      https://openradar.appspot.com/10114310
    NSMutableOrderedSet *instruments = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.instruments];
    for (Instrument* i in self.instruments) {
        [instruments addObject:(Instrument*)[i clone]];
    }
    self.instruments = instruments;

    return e;
}

@end
