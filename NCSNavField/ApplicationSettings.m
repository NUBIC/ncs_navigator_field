//
//  Configuration.m
//  NCSNavField
//
//  Created by John Dzak on 1/16/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//
/*
 This represents a thin wrapper around the NSUserDefaults that we set for the user. We either pull these from the defaults that 
 is containted in the Settings bundle in the Root.plist.
 */
#import "ApplicationSettings.h"
#import "NSString+Additions.h"

NSString* const SettingsDidChangeNotification = @"ApplicationSettingsChanged";
NSString* const CLIENT_ID = @"client.id";
NSString* const CORE_URL = @"navigator.core.url";
NSString* const CAS_SERVER_URL = @"cas.server.url";
NSString* const PGT_RECEIVE_URL = @"pgt.receive.url";
NSString* const PGT_RETRIEVE_URL = @"pgt.retrieve.url";
NSString* const PURGE_FIELDWORK_BUTTON = @"purge.fieldwork.button";
NSString* const UPCOMING_DAYS_TO_SYNC = @"upcoming.days.to.sync";
NSString* const PAST_DAYS_TO_SYNC = @"past.days.to.sync";

//This makes the method declaration private. This is a singleton
//and we don't want any consumers of this class to call the init method.
//We want them to call the instance class method. That enforces its
//singleton-ness.
@interface ApplicationSettings ()
-(id)init;
@end

@implementation ApplicationSettings

@synthesize coreURL=_coreURL;
@synthesize clientId=_clientId;
@synthesize casServerURL=_casServerURL;
@synthesize pgtReceiveURL=_pgtReceiveURL;
@synthesize pgtRetrieveURL=_pgtRetrieveURL;
@synthesize purgeFieldworkButton=_purgeFieldworkButton;
@synthesize upcomingDaysToSync=_upcomingDaysToSync;

static ApplicationSettings* instance;

- (id)init {
        self = [super init];
        if (self) {
            _clientId = [self retreiveClientId];
            _coreURL = [self retreiveCoreURL];
            _casServerURL = [self casServerURL];
            _pgtReceiveURL = [self pgtReceiveURL];
            _pgtRetrieveURL = [self pgtRetrieveURL];
            _purgeFieldworkButton = [self isPurgeFieldworkButton];
            _upcomingDaysToSync = [self upcomingDaysToSync];
            _pastDaysToSync = [self pastDaysToSync];
            //[[NSNotificationCenter defaultCenter] postNotificationName:SettingsDidChangeNotification object:self];
            [self registerDefaultsFromSettingsBundle];

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
    self.purgeFieldworkButton = [self purgeFieldworkButton];
    self.upcomingDaysToSync = [self upcomingDaysToSync];
    self.pastDaysToSync = [self pastDaysToSync];
    //We need this. 
    [[NSNotificationCenter defaultCenter] postNotificationName:SettingsDidChangeNotification object:self];
}

- (NSString*) retreiveClientId {
    NSString *cid = [[NSUserDefaults standardUserDefaults] stringForKey:CLIENT_ID];
    if (cid == nil)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL,uuidRef));
        CFRelease(uuidRef);
        [[NSUserDefaults standardUserDefaults] setValue:uuid forKey:CLIENT_ID];
    }
    return cid;
}
#pragma mark - Accessor methods for User Settings

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

- (BOOL) isPurgeFieldworkButton {
    return [[NSUserDefaults standardUserDefaults] boolForKey:PURGE_FIELDWORK_BUTTON];
}

- (NSInteger) upcomingDaysToSync {
    return [[NSUserDefaults standardUserDefaults] integerForKey:UPCOMING_DAYS_TO_SYNC];
}

- (NSInteger) pastDaysToSync {
    return [[NSUserDefaults standardUserDefaults] integerForKey:PAST_DAYS_TO_SYNC];
}

+ (CasConfiguration*) casConfiguration {
    ApplicationSettings* s = [ApplicationSettings instance];
    return [[CasConfiguration alloc] initWithCasURL:s.casServerURL receiveURL:s.pgtReceiveURL retrieveURL:s.pgtRetrieveURL];
}

- (BOOL) coreSynchronizeConfigured:(NSString**)strResults {
    if([_coreURL length]==0) {
        *strResults = @"NCS Navigator Core URL";
        return NO;
    }
    if([_casServerURL length]==0) {
        *strResults = @"CAS Server URL";
        return NO;
    }
    if([_pgtReceiveURL length]==0) {
        *strResults = @"Receive PGT URL";
        return NO;
    }
    if([_pgtRetrieveURL length]==0) {
        *strResults = @"Retrieve PGT URL";
        return NO;
    }
    return YES;
}

#pragma mark Register User Defaults from Settings Bundle

//Should we throw an exception here if the Settings.bundle is not found? Isn't that a fatal error? 
- (void)registerDefaultsFromSettingsBundle {
    NSLog(@"Registering default values from Settings.bundle");
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    [defs synchronize];
    
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    
    if(!settingsBundle)
    {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    
    for (NSDictionary *prefSpecification in preferences)
    {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if (key)
        {
            // check if value readable in userDefaults
            id currentObject = [defs objectForKey:key];
            if (currentObject == nil)
            {
                // not readable: set value from Settings.bundle
                id objectToSet = [prefSpecification objectForKey:@"DefaultValue"];
                if (objectToSet) {
                    [defaultsToRegister setObject:objectToSet forKey:key];
                    NSLog(@"Setting object %@ for key %@", objectToSet, key);
                }
            }
            else
            {
                // already readable: don't touch
                NSLog(@"Key %@ is readable (value: %@), nothing written to defaults.", key, currentObject);
            }
        }
    }
    
    [defs registerDefaults:defaultsToRegister];
    [defs synchronize];
}

-(NSString*)lastModifiedSinceForProviders {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"lastModifiedProviders"];
}

-(void)setLastModifiedSinceForProviders:(NSString*)str {
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"lastModifiedProviders"];
}

-(void)deleteLastModifiedSinceDates {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastModifiedProviders"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastModifiedCodes"];
}

-(NSString*)lastModifiedSinceForCodes {
    return [[NSUserDefaults standardUserDefaults] valueForKey:@"lastModifiedCodes"];
}

-(void)setLastModifiedSinceForCodes:(NSString*)str {
    [[NSUserDefaults standardUserDefaults] setValue:str forKey:@"lastModifiedCodes"];
}

@end
