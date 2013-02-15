//
//  NUEndpointMockService.m
//  NCSNavField
//
//  Created by Jacob Van Order on 2/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointMockService.h"
#import "NUEndpoint.h"
#import "NUEndpointEnvironment.h"
#import "RestKitSettings.h"

@implementation NUEndpointMockService

#pragma mark delegate methods

#pragma mark customization

-(void)getEndpointArrayWithCallback:(void (^)(NSArray *, NSError *))endpointBlock {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSArray *endpointArray = @[];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"testEndpointJSONExample" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        NSError *jsonError = nil;
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
        for (NSDictionary *endpointDictionary in dataDictionary[@"locations"]) {
            NUEndpoint *newEndpoint = [[NUEndpoint alloc] initWithDataDictionary:endpointDictionary];
            endpointArray = [endpointArray arrayByAddingObject:newEndpoint];
        }
        endpointBlock (endpointArray, jsonError);
    });
}

-(BOOL)userDidChooseEndpoint:(NUEndpoint *)chosenEndpoint {
    NSString *libraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    libraryDirectory = [libraryDirectory stringByAppendingFormat:@"/userEndpoint.plist"];
    BOOL wasSuccessful = [NSKeyedArchiver archiveRootObject:chosenEndpoint toFile:libraryDirectory];
    [self writeEndpointToDefaults:chosenEndpoint];
    [RestKitSettings reload];
    return wasSuccessful;
}

-(BOOL)deleteUserEndpoint {
    NSString *libraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [libraryDirectory stringByAppendingString:@"/userEndpoint.plist"];
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

-(NUEndpoint *)userEndpointOnDisk {
    NSString *libraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [libraryDirectory stringByAppendingString:@"/userEndpoint.plist"];
    NUEndpoint *endpoint = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return endpoint;
}

-(void)stopNetworkRequest {
    
}

#pragma mark prototyping

-(void) writeEndpointToDefaults:(NUEndpoint *)endpoint {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:endpoint.enviroment.coreURL.absoluteString forKey:CORE_URL];
    [defaults setObject:endpoint.enviroment.pgtReceiveURL.absoluteString forKey:PGT_RECEIVE_URL];
    [defaults setObject:endpoint.enviroment.pgtRetrieveURL.absoluteString forKey:PGT_RETRIEVE_URL];
    [defaults setObject:endpoint.enviroment.casServerURL.absoluteString forKey:CAS_SERVER_URL];
}

- (void)settingsChanged:(NSNotification *)notif
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:MANUAL_MODE] == YES) {
        [RestKitSettings reload];
    }
}

#pragma mark stock code

-(instancetype)init {
    
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

@end
