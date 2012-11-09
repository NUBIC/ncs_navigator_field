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
    return @{
        @"provider_id": self.provider.location,
        @"practice_num": self.provider.practiceNum,
        @"name_practice": self.provider.name,
        @"mode_of_contact": @"capi"
    };
}

@end
