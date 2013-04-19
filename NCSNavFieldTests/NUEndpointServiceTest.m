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
        
    NSArray *liveServiceEndpointArray = [[NUEndpointService service] synchronousEndpointRequestFromString:[self threeEndpointJsonString]];
    STAssertTrue(([liveServiceEndpointArray count] == 3), @"The number of endpoints is not equal to the number of locations in JSON");
}

-(void)testNUEndpointImage {
    
    NUEndpoint *newEndpoint = [[NUEndpoint alloc] init];
    newEndpoint.imageURL = [NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/3/30/Googlelogo.png"];
    
    while (newEndpoint.endpointImage == nil)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
    STAssertNotNil(newEndpoint.endpointImage, @"endpoint image didn't load.");
}

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
