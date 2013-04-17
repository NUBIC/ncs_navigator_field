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
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
    [[NUEndpointService service] getEndpointArrayWithCallback:^(NSArray *endpointArray, NSError *error) {
        BOOL endpointOnlyContainsManualEndpoint = ([endpointArray count] > 1 && [[[endpointArray lastObject] isManualEndpoint] isEqualToNumber:@YES]);
        STAssertTrue(endpointOnlyContainsManualEndpoint, @"The endpoint that came back was only a manual version");
        STAssertNil(error, [NSString stringWithFormat:@"Error for NUEndpointService: %@", [error description]]);
        
        dispatch_semaphore_signal(semaphore);
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
