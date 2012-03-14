//
//  Configuration.m
//  NCSMobile
//
//  Created by John Dzak on 1/16/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationConfiguration.h"

NSString* CLIENT_ID = @"client.id";
NSString* CORE_URL = @"navigator.core.url";

@implementation ApplicationConfiguration

@synthesize coreURL=_coreURL;
@synthesize clientId=_clientId;

static ApplicationConfiguration* instance;


- (id)init {
    self = [super init];
    if (self) {
        _clientId = [[self retreiveClientId] retain];
        _coreURL = [[self retreiveCoreURL] retain];
    }
    
    return self;
}

+ (ApplicationConfiguration*) instance {
    if (!instance) {
        instance = [[ApplicationConfiguration alloc] init];
    }
    return instance;
}

+ (void) reload {
    [[ApplicationConfiguration instance] reload];
}

- (void) reload {
    self.clientId = [self retreiveClientId];
    self.coreURL = [self retreiveCoreURL];
}

- (NSString*) retreiveClientId {
    NSString *cid = [[NSUserDefaults standardUserDefaults] stringForKey:CLIENT_ID];
    if (cid == nil)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuid = (NSString *)CFUUIDCreateString(NULL,uuidRef);
        CFRelease(uuidRef);
        [[NSUserDefaults standardUserDefaults] setValue:uuid forKey:CLIENT_ID];
    }
    return cid;
}

- (NSString*) retreiveCoreURL {
    return [[NSUserDefaults standardUserDefaults] stringForKey:CORE_URL];
}

- (void)dealloc {
    [_coreURL release];
    [_clientId release];
    [super dealloc];
}
@end
