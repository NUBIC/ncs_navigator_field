//
//  Configuration.h
//  NCSMobile
//
//  Created by John Dzak on 1/16/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationSettings : NSObject {
    @private
    NSString* _coreURL;
    NSString* _clientId;
}

#pragma mark properties

@property(nonatomic,retain) NSString* coreURL;

@property(nonatomic,retain) NSString* clientId;


#pragma Methods

+ (ApplicationSettings*) instance;

+ (void) reload;

- (void) reload;

- (NSString*) retreiveClientId;

- (NSString*) retreiveCoreURL;

@end
