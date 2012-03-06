//
//  Configuration.m
//  NCSMobile
//
//  Created by John Dzak on 1/16/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationConfiguration.h"

@implementation ApplicationConfiguration

@synthesize coreURL;

static ApplicationConfiguration* instance;


- (id)init {
    self = [super init];
    if (self) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"NCSNavigatorField" ofType:@"plist"];
        
        if (!path) {
            NSLog(@"NUCas.plist not found at %@/NCSNavigatorField.plist", [NSBundle mainBundle]);
        }
        
        NSDictionary* settings = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        self.coreURL = [settings objectForKey:@"ncs.core.url"];
    }
    
    return self;
}

+ (ApplicationConfiguration*) instance {
    if (!instance) {
        instance = [[ApplicationConfiguration alloc] init];
    }
    return instance;
}

@end
