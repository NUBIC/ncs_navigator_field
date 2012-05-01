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
}

#pragma mark properties

@property(nonatomic,retain) NSString* coreURL;

@property(nonatomic,retain) NSString* clientId;

@property(nonatomic,retain) NSString* casServerURL;

@property(nonatomic,retain) NSString* pgtReceiveURL;

@property(nonatomic,retain) NSString* pgtRetrieveURL;


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

@end
