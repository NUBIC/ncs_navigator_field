//
//  Configuration.h
//  NCSNavField
//
//  Created by John Dzak on 1/16/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NUEndpoint;

@interface ApplicationSettings : NSObject

#pragma mark properties

@property(nonatomic,strong) NSString* coreURL;
@property(nonatomic,strong) NSString* clientId;
@property(nonatomic,strong) NSString* casServerURL;
@property(nonatomic,strong) NSString* pgtReceiveURL;
@property(nonatomic,strong) NSString* pgtRetrieveURL;
@property(nonatomic) BOOL purgeFieldworkButton;
@property(nonatomic) NSInteger upcomingDaysToSync;
@property (nonatomic, assign, readonly) BOOL isInManualMode;

@property (nonatomic, assign) NSInteger pastDaysToSync;

#pragma Methods

+ (ApplicationSettings*) instance;

+ (CasConfiguration*) casConfiguration;

- (BOOL) isPurgeFieldworkButton;

- (void)registerDefaultsFromSettingsBundle;

- (BOOL) coreSynchronizeConfigured:(NSString**)strResults;

-(NSString*)lastModifiedSinceForProviders;

-(void)setLastModifiedSinceForProviders:(NSString*)str;

-(NSString*)lastModifiedSinceForCodes;

-(void)setLastModifiedSinceForCodes:(NSString*)str;

-(void)deleteLastModifiedSinceDates;

-(void)updateWithEndpoint:(NUEndpoint *)endpoint;

@end
