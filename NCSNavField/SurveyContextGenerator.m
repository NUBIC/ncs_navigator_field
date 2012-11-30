//
//  SurveyContextGenerator.m
//  NCSNavField
//
//  Created by John Dzak on 11/8/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "SurveyContextGenerator.h"

#import "Provider.h"

@implementation SurveyContextGenerator

@synthesize provider = _provider;

- (id)initWithProvider:(Provider*)provider {
    if (self = [self init]) {
        self.provider = provider;
    }
    return self;
}

- (id)context {
    NSMutableDictionary* ctx = [NSMutableDictionary new];
    
    if (self.provider) {
        if (self.provider.location) {
            [ctx setObject:self.provider.location
                    forKey:@"provider_id"];
        }
        
        if (self.provider.practiceNum) {
            [ctx setObject:self.provider.practiceNum
                    forKey:@"practice_num"];
        }
        
        if (self.provider.name) {
            [ctx setObject:self.provider.name
                    forKey:@"name_practice"];
        }
        
        [ctx setObject:@"capi" forKey:@"mode_of_contact"];
    }
    
    return ctx;
}

@end
