//
//  Configuration.h
//  NCSNavField
//
//  Created by John Dzak on 1/16/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationSettings : NSObject {
    @private
    NSString* _coreURL;
    NSString* _clientId;
    NSString* _casServerURL;
    NSString* _pgtReceiveURL;
    NSString* _pgtRetrieveURL;
    BOOL _purgeFieldworkButton;
    NSInteger _upcomingDaysToSync;
}

#pragma mark properties

@property(nonatomic,strong) NSString* coreURL;

@property(nonatomic,strong) NSString* clientId;

@property(nonatomic,strong) NSString* casServerURL;

@property(nonatomic,strong) NSString* pgtReceiveURL;

@property(nonatomic,strong) NSString* pgtRetrieveURL;

@property(nonatomic) BOOL purgeFieldworkButton;

@property(nonatomic) NSInteger upcomingDaysToSync;

#pragma Methods

+ (ApplicationSettings*) instance;

+ (void) reload;

- (void) reload;

- (NSString*) retreiveClientId;

- (NSString*) retreiveCoreURL;

- (NSString*) casServerURL;

- (NSString*) pgtReceiveURL;

- (NSString*) pgtRetrieveURL;

+ (CasConfiguration*) casConfiguration;

- (BOOL) isPurgeFieldworkButton;

- (NSInteger) upcomingDaysToSync;

- (void)registerDefaultsFromSettingsBundle;

- (BOOL) coreSynchronizeConfigured:(NSString**)strResults;

-(NSString*)lastModifiedSinceForProviders;

-(void)setLastModifiedSinceForProviders:(NSString*)str;

-(NSString*)lastModifiedSinceForCodes;

-(void)setLastModifiedSinceForCodes:(NSString*)str;

-(void)deleteLastModifiedSinceDates;
@end
