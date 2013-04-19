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

#import "Nocilla.h"

@implementation NUEndpointServiceTest

-(void)setUp {
    [[LSNocilla sharedInstance] start];
}

-(void)tearDown {
    [[LSNocilla sharedInstance] stop];
}

-(void)testNUEndpointServiceResponse {
    
    NSDictionary *endpointPrefDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NCSNavField-environment" ofType:@"plist"]];
    
    stubRequest(@"GET", endpointPrefDictionary[@"locationServiceURL"]).withBody([self threeEndpointJsonString]);
    
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    int __block wait = 0;
    
    [[NUEndpointService service] getEndpointArrayWithCallback:^(NSArray *endpointArray, NSError *error) {
        STAssertTrue(([endpointArray count] == 3), @"The incorrect amount of endpoints came back.");
        STAssertNil(error, [NSString stringWithFormat:@"Error for NUEndpointService: %@", [error description]]);
        
//        dispatch_semaphore_signal(semaphore);
        wait = 1;
    }];
    
//    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
//                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
//    dispatch_release(semaphore);
    while (wait == 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
}

//-(void)testNUEndpointImage {
//    
//    NUEndpoint *newEndpoint = [[NUEndpoint alloc] init];
//    newEndpoint.imageURL = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/3/30/Googlelogo.png"];
//    
//    while (newEndpoint.endpointImage == nil)
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
//                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
//    
//    STAssertNotNil(newEndpoint.endpointImage, @"endpoint image didn't load.");
//}

-(NSString *)threeEndpointJsonString {
    return @"{"
    "    \"locations\": ["
    "        {"
    "            \"environments\": ["
    "                {"
    "                    \"cas_base_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas\", "
    "                    \"cas_proxy_receive_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\", "
    "                    \"cas_proxy_retrieve_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\", "
    "                    \"cases_url\": \"https://bcm-navcases-staging.nubic.northwestern.edu\", "
    "                    \"name\": \"staging\""
    "                }, "
    "                {"
    "                    \"cas_base_url\": \"https://ncscas.nubic.northwestern.edu/cas\", "
    "                    \"cas_proxy_receive_url\": \"https://ncscas.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\", "
    "                    \"cas_proxy_retrieve_url\": \"https://ncscas.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\", "
    "                    \"cases_url\": \"https://bcm-navcases.nubic.northwestern.edu\", "
    "                    \"name\": \"production\""
    "                }"
    "            ], "
    "            \"logo_url\": \"https://navfield.nubic.northwestern.edu/locations/images/harris_county.jpg\", "
    "            \"name\": \"Harris County\""
    "        }, "
    "        {"
    "            \"environments\": ["
    "                {"
    "                    \"cas_base_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas\", "
    "                    \"cas_proxy_receive_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\", "
    "                    \"cas_proxy_retrieve_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\", "
    "                    \"cases_url\": \"https://umass-navcases-staging.nubic.northwestern.edu\", "
    "                    \"name\": \"staging\""
    "                }, "
    "                {"
    "                    \"cas_base_url\": \"https://ncscas.nubic.northwestern.edu/cas\", "
    "                    \"cas_proxy_receive_url\": \"https://ncscas.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\", "
    "                    \"cas_proxy_retrieve_url\": \"https://ncscas.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\", "
    "                    \"cases_url\": \"https://umass-navcases.nubic.northwestern.edu\", "
    "                    \"name\": \"production\""
    "                }"
    "            ], "
    "            \"logo_url\": \"https://navfield.nubic.northwestern.edu/locations/images/umass.jpg\", "
    "            \"name\": \"Worcester County\""
    "        }, "
    "        {"
    "            \"environments\": ["
    "                {"
    "                    \"cas_base_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas\", "
    "                    \"cas_proxy_receive_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\", "
    "                    \"cas_proxy_retrieve_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\", "
    "                    \"cases_url\": \"https://uofl-navcases-staging.nubic.northwestern.edu\", "
    "                    \"name\": \"staging\""
    "                }, "
    "                {"
    "                    \"cas_base_url\": \"https://ncscas.nubic.northwestern.edu/cas\", "
    "                    \"cas_proxy_receive_url\": \"https://ncscas.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\", "
    "                    \"cas_proxy_retrieve_url\": \"https://ncscas.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\", "
    "                    \"cases_url\": \"https://uofl-navcases.nubic.northwestern.edu\", "
    "                    \"name\": \"production\""
    "                }"
    "            ], "
    "            \"logo_url\": \"https://navfield.nubic.northwestern.edu/locations/images/jefferson_county.jpg\", "
    "            \"name\": \"Jefferson County\""
    "        }"
    "   ] "
    "}";
}
@end
