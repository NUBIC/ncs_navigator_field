//
//  NUEndpointLiveService.m
//  NCSNavField
//
//  Created by Jacob Van Order on 2/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointLiveService.h"
#import "NUEndpoint.h"
#import "NUEndpointEnvironment.h"
#import "RKReachabilityObserver.h"
#import "RestKitSettings.h"
#import "ApplicationSettings.h"

@interface NUEndpointLiveService () <NSURLConnectionDataDelegate>

@property (nonatomic, strong) void (^endpointBlock)(NSArray *endpointArray, NSError *endpointError);
@property (nonatomic, strong) NSURLConnection *endpointConnection;
@property (nonatomic, strong) NSMutableData *receivedData;

- (void)settingsChanged:(NSNotification *)notif;

@end

@implementation NUEndpointLiveService

#pragma mark delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.receivedData = [NSMutableData data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSArray *endpointArray = @[];
    NSError *jsonError = nil;
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:&jsonError];
    for (NSDictionary *endpointDictionary in dataDictionary[@"locations"]) {
        NUEndpoint *newEndpoint = [[NUEndpoint alloc] initWithDataDictionary:endpointDictionary];
        endpointArray = [endpointArray arrayByAddingObject:newEndpoint];
    }
    if (self.endpointBlock) {
        self.endpointBlock (endpointArray, jsonError);
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.endpointBlock(nil, error);
}

#pragma mark customization

-(void)getEndpointArrayWithCallback:(void (^)(NSArray *, NSError *))endpointBlock {
        self.endpointBlock = endpointBlock;
        NSDictionary *endpointPrefDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NCSNavField-environment" ofType:@"plist"]];
        NSURL *locationServiceURL = [NSURL URLWithString:endpointPrefDictionary[@"locationServiceURL"]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:locationServiceURL cachePolicy:NSURLCacheStorageAllowed timeoutInterval:30.0f];
        self.endpointConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        [self.endpointConnection start];
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
    [self.endpointConnection cancel];
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
        [[ApplicationSettings instance] updateWithEndpoint:nil];
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
