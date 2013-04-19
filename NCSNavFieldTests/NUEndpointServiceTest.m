//
//  NUEndpointServiceTest.m
//  NCSNavField
//
//  Created by Jacob Van Order on 4/17/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointServiceTest.h"

#import "NUEndpointService.h"
#import "NUEndpoint.h"


@implementation NUEndpointServiceTest

-(void)setUp {
}

-(void)tearDown {
}

-(void)testNUEndpointServiceResponse {
    
    NSDictionary *endpointPrefDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NCSNavField-environment" ofType:@"plist"]];
        
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:endpointPrefDictionary[@"locationServiceURL"]]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        STAssertNil(error, @"the connection failed in the first place.");
        
        NSError *jsonError = nil;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        int numberOfEndpoints = [jsonDictionary[@"locations"] count];
        STAssertNil(jsonError, @"There was an issue with the json.");
        
        [[NUEndpointService service] getEndpointArrayWithCallback:^(NSArray *endpointArray, NSError *error) {
            STAssertTrue(([endpointArray count] == numberOfEndpoints), @"The incorrect amount of endpoints came back.");
            STAssertNil(error, [NSString stringWithFormat:@"Error for NUEndpointService: %@", [error description]]);
            
            dispatch_semaphore_signal(semaphore);
        }];
    }];
    

    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    dispatch_release(semaphore);
}

-(void)testNUEndpointImage {
    
    NUEndpoint *newEndpoint = [[NUEndpoint alloc] init];
    newEndpoint.imageURL = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/3/30/Googlelogo.png"];
    
    while (newEndpoint.endpointImage == nil)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
    STAssertNotNil(newEndpoint.endpointImage, @"endpoint image didn't load.");
}

@end
