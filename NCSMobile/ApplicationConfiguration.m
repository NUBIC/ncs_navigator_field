//
//  Configuration.m
//  NCSMobile
//
//  Created by John Dzak on 1/16/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationConfiguration.h"

NSString* CLIENT_ID = @"clientId";

@implementation ApplicationConfiguration

@synthesize coreURL=_coreURL;
@synthesize clientId=_clientId;

static ApplicationConfiguration* instance;


- (id)init {
    self = [super init];
    if (self) {
        // Core URL from NCSNavigatorField.plist
        NSString* path = [[NSBundle mainBundle] pathForResource:@"NCSNavigatorField" ofType:@"plist"];
        
        if (!path) {
            NSLog(@"NUCas.plist not found at %@/NCSNavigatorField.plist", [NSBundle mainBundle]);
        }
        
        NSDictionary* settings = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        _coreURL = [[settings objectForKey:@"ncs.core.url"] retain];
        
        // Client ID from Preferences
        NSString *cid = [[NSUserDefaults standardUserDefaults] stringForKey:CLIENT_ID];
        if (cid == nil)
        {
            CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
            NSString *uuid = (NSString *)CFUUIDCreateString(NULL,uuidRef);
            CFRelease(uuidRef);
            
            [[NSUserDefaults standardUserDefaults] setValue:uuid forKey:CLIENT_ID];
        }
        _clientId = [cid retain];
    }
    
    return self;
}

+ (ApplicationConfiguration*) instance {
    if (!instance) {
        instance = [[ApplicationConfiguration alloc] init];
    }
    return instance;
}

- (void)dealloc {
    [_coreURL release];
    [_clientId release];
    [super dealloc];
}
@end
