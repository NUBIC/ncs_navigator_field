//
//  ResponseSetMustacheContext.m
//  NCSNavField
//
//  Created by John Dzak on 2/20/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "ResponseSetMustacheContext.h"
#import "ResponseSet.h"
#import "Response.h"
#import "NUSurvey+Additions.h"
#import "InstrumentTemplate.h"
#import "NUQuestion.h"
#import <RestKit/RestKit.h>
#import <MRCEnumerable/MRCEnumerable.h>

@implementation ResponseSetMustacheContext

- (ResponseSetMustacheContext*)initWithResponseSet:(ResponseSet*)rs {
    self = [self init];
    if (self) {
        self.responseSet = rs;
    }
    return self;
}

- (NSDictionary*)toDictionary {
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    if (self.responseSet) {
        InstrumentTemplate* template = [[NUSurvey findByUUUID:self.responseSet.survey] instrumentTemplate];
        if (template) {
            for (Response* response in self.responseSet.responses) {
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"instrumentTemplate == %@ AND uuid == %@", template, response.question];
                NUQuestion* question = [NUQuestion findFirstWithPredicate:predicate];
                if ([question isHelperQuestion]) {
                    [dictionary setValue:response.value forKey:[question referenceIdentifierWithoutHelperPrefix]];
                }
            }
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
