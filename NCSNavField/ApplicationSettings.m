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
#import "NUEndpoint.h"
#import "NUEndpointEnvironment.h"
#import "RestKitSettings.h"

//This makes the method declaration private. This is a singleton
//and we don't want any consumers of this class to call the init method.
//We want them to call the instance class method. That enforces its
//singleton-ness.
@interface ApplicationSettings ()

@property (nonatomic, strong) NUEndpoint *endpoint;

-(id)init;

@end

@implementation ApplicationSettings

- (id)init {
        self = [super init];
        if (self) {
            _clientId = [self clientId];
            _purgeFieldworkButton = [self isPurgeFieldworkButton];
            _upcomingDaysToSync = [self upcomingDaysToSync];
            _pastDaysToSync = [self pastDaysToSync];
            //[[NSNotificationCenter defaultCenter] postNotificationName:SettingsDidChangeNotification object:self];
            [self registerDefaultsFromSettingsBundle];
            _endpoint = [NUEndpoint userEndpointOnDisk];
        }
        return self;
}

+ (ApplicationSettings*) instance {
    static ApplicationSettings* instance;
    if (!instance) {
        instance = [[ApplicationSettings alloc] init];
    }
    return instance;
}

- (NSString*) clientId {
    
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    NSDictionary *clientIdDictionary = [[preferences filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Key == %@", CLIENT_ID]] lastObject];
    NSString *defaultClientId = nil;
    if (clientIdDictionary != nil) {
        defaultClientId = clientIdDictionary[@"DefaultValue"];
    }
    _clientId = [[NSUserDefaults standardUserDefaults] stringForKey:CLIENT_ID];
    if (_clientId == nil || [_clientId isEqual:defaultClientId] == YES)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        _clientId = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL,uuidRef));
        CFRelease(uuidRef);
        [[NSUserDefaults standardUserDefaults] setValue:_clientId forKey:CLIENT_ID];
    }
    return _clientId;
}
#pragma mark - Accessor methods for User Settings

- (NSString *) coreURL {
    if (_coreURL) {
        return _coreURL;
    }
    if (self.endpoint == nil) {
        self.endpoint = [NUEndpoint userEndpointOnDisk];
    }
    NSString *returnString = self.endpoint.enviroment.coreURL.absoluteString;
    if (returnString == nil) {
        returnString = [[NSUserDefaults standardUserDefaults] stringForKey:CORE_URL];
    }
    return returnString;
}

- (NSString*) casServerURL {
    if (_casServerURL) {
        return _casServerURL;
    }
    if (self.endpoint == nil) {
        self.endpoint = [NUEndpoint userEndpointOnDisk];
    }
    NSString *returnString = self.endpoint.enviroment.casServerURL.absoluteString;
    if (returnString == nil) {
        returnString = [[NSUserDefaults standardUserDefaults] stringForKey:CAS_SERVER_URL];
    }
    return returnString;
}

- (NSString*) pgtReceiveURL {
    if (_pgtReceiveURL) {
        return _pgtReceiveURL;
    }
    if (self.endpoint == nil) {
        self.endpoint = [NUEndpoint userEndpointOnDisk];
    }
    NSString *returnString = self.endpoint.enviroment.pgtReceiveURL.absoluteString;
    if (returnString == nil) {
        returnString = [[NSUserDefaults standardUserDefaults] stringForKey:PGT_RECEIVE_URL];
    }
    return returnString;
}

- (NSString*) pgtRetrieveURL {
    if (_pgtRetrieveURL) {
        return _pgtRetrieveURL;
    }
    if (self.endpoint == nil) {
        self.endpoint = [NUEndpoint userEndpointOnDisk];
    }
    NSString *returnString = self.endpoint.enviroment.pgtRetrieveURL.absoluteString;
    if (returnString == nil) {
        returnString = [[NSUserDefaults standardUserDefaults] stringForKey:PGT_RETRIEVE_URL];
    }
    return returnString;
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
    if([self.coreURL length]==0) {
        *strResults = @"NCS Navigator Core URL";
        return NO;
    }
    if([self.casServerURL length]==0) {
        *strResults = @"CAS Server URL";
        return NO;
    }
    if([self.pgtReceiveURL length]==0) {
        *strResults = @"Receive PGT URL";
        return NO;
    }
    if([self.pgtRetrieveURL length]==0) {
        *strResults = @"Retrieve PGT URL";
        return NO;
    }
    return YES;
}

#pragma mark Register User Defaults from Settings Bundle

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

-(void)updateWithEndpoint:(NUEndpoint *)endpoint {
    self.endpoint = endpoint;
    self.coreURL = [endpoint.enviroment.coreURL absoluteString];
    self.casServerURL = [endpoint.enviroment.casServerURL absoluteString];
    self.pgtReceiveURL = [endpoint.enviroment.pgtReceiveURL absoluteString];
    self.pgtRetrieveURL = [endpoint.enviroment.pgtRetrieveURL absoluteString];
    self.purgeFieldworkButton = [self purgeFieldworkButton];
    self.upcomingDaysToSync = [self upcomingDaysToSync];
    self.pastDaysToSync = [self pastDaysToSync];
    [endpoint writeToDisk];
    [[NSNotificationCenter defaultCenter] postNotificationName:SettingsDidChangeNotification object:self];
    [RestKitSettings reload];
}

@end
