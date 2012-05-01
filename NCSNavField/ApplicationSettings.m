//
//  Configuration.m
//  NCSNavField
//
//  Created by John Dzak on 1/16/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationSettings.h"

NSString* CLIENT_ID = @"client.id";
NSString* CORE_URL = @"navigator.core.url";
NSString* CAS_SERVER_URL = @"cas.server.url";
NSString* PGT_RECEIVE_URL = @"pgt.receive.url";
NSString* PGT_RETRIEVE_URL = @"pgt.retrieve.url";

@implementation ApplicationSettings

@synthesize coreURL=_coreURL;
@synthesize clientId=_clientId;
@synthesize casServerURL=_casServerURL;
@synthesize pgtReceiveURL=_pgtReceiveURL;
@synthesize pgtRetrieveURL=_pgtRetrieveURL;

static ApplicationSettings* instance;

- (id)init {
    self = [super init];
    if (self) {
        _clientId = [[self retreiveClientId] retain];
        _coreURL = [[self retreiveCoreURL] retain];
        _casServerURL = [[self casServerURL] retain];
        _pgtReceiveURL = [[self pgtReceiveURL] retain];
        _pgtRetrieveURL = [[self pgtRetrieveURL] retain];
    }
    
    return self;
}

+ (ApplicationSettings*) instance {
    if (!instance) {
        instance = [[ApplicationSettings alloc] init];
    }
    return instance;
}

+ (void) reload {
    [[ApplicationSettings instance] reload];
}

- (void) reload {
    self.clientId = [self retreiveClientId];
    self.coreURL = [self retreiveCoreURL];
    self.casServerURL = [self casServerURL];
    self.pgtReceiveURL = [self pgtReceiveURL];
    self.pgtRetrieveURL = [self pgtRetrieveURL];
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

- (NSString*) casServerURL {
    return [[NSUserDefaults standardUserDefaults] stringForKey:CAS_SERVER_URL];
}

- (NSString*) pgtReceiveURL {
    return [[NSUserDefaults standardUserDefaults] stringForKey:PGT_RECEIVE_URL];
}

- (NSString*) pgtRetrieveURL {
    return [[NSUserDefaults standardUserDefaults] stringForKey:PGT_RETRIEVE_URL];
}

+ (CasConfiguration*) casConfiguration {
    ApplicationSettings* s = [ApplicationSettings instance];
    return [[CasConfiguration alloc] initWithCasURL:s.casServerURL receiveURL:s.pgtReceiveURL retrieveURL:s.pgtRetrieveURL];
}

- (void)dealloc {
    [_coreURL release];
    [_clientId release];
    [_casServerURL release];
    [_pgtReceiveURL release];
    [_pgtRetrieveURL release];
    [super dealloc];
}
@end
