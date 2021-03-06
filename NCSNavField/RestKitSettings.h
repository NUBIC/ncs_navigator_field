//
//  RestKitSettings.h
//  NCSNavField
//
//  Created by John Dzak on 3/6/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>
@class RKObjectManager;

@interface RestKitSettings : NSObject {
    NSString* _baseServiceURL;
    NSString* _objectStoreFileName;
}

@property(nonatomic,strong) NSString* baseServiceURL;

@property(nonatomic,strong) NSString* objectStoreFileName;

+ (RestKitSettings*) instance;

+ (void) reload;

- (id) init;

//- (id)initWithBaseServiceURL:(NSString*)url objectStoreFileName:(NSString*)file;

- (void)introduce;

- (void)addMappingsToObjectManager:(RKObjectManager *)objectManager;

- (void)addSerializationMappingsToObjectManager:(RKObjectManager*)objectManager;

- (BOOL) RSRunningOnOS4OrBetter;

-(void)addOptionMappingsToObjectManager:(RKObjectManager*)objectManager;


@end
