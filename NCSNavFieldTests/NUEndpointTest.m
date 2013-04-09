//
//  NUEndpointTest.m
//  NCSNavField
//
//  Created by Jacob Van Order on 3/25/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointTest.h"

#import "NUEndpoint.h"
#import "NUEndpointEnvironment.h"

@interface NUEndpointTest ()

@property (nonatomic, strong) NSString *dataString;
@property (nonatomic, strong) NSDictionary *dataDictionary;
@property (nonatomic, strong) NSArray *endpointArray;

@end

@implementation NUEndpointTest

-(void)setUp {
    [super setUp];
    self.dataString = @" {"
                            "\"locations\": ["
                                "{"
                                    "\"name\": \"Northwestern\","
                                    "\"logo_url\": \"http://download.nubic.northwestern.edu/ncs_navigator_locations/images/harris_county.jpg\","
                                    "\"environments\": ["
                                           "{"
                                               "\"name\": \"staging\","
                                               "\"cases_url\": \"https://training-navcases.nubic.northwestern.edu\","
                                               "\"cas_base_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas\","
                                               "\"cas_proxy_retrieve_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\","
                                               "\"cas_proxy_receive_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\""
                                           "},"
                                           "{"
                                               "\"name\": \"production\","
                                               "\"cases_url\": \"https://bcm-navcases-staging.nubic.northwestern.edu\","
                                               "\"cas_base_url\": \"https://bcm-ncscas-staging.nubic.northwestern.edu/cas\","
                                               "\"cas_proxy_retrieve_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\","
                                               "\"cas_proxy_receive_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\""
                                           "}"
                                           "]"
                                "},"
                                "{"
                                    "\"name\": \"UMass\","
                                    "\"logo_url\": \"http://download.nubic.northwestern.edu/ncs_navigator_locations/images/umass.jpg\","
                                    "\"environments\": ["
                                           "{"
                                               "\"name\": \"staging\","
                                               "\"cases_url\": \"https://training-navcases.nubic.northwestern.edu\","
                                               "\"cas_base_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas\","
                                               "\"cas_proxy_retrieve_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\","
                                               "\"cas_proxy_receive_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\""
                                           "},"
                                           "{"
                                               "\"name\": \"production\","
                                               "\"cases_url\": \"https://umass-navcases-staging.nubic.northwestern.edu\","
                                               "\"cas_base_url\": \"https://umass-ncscas-staging.nubic.northwestern.edu/cas\","
                                               "\"cas_proxy_retrieve_url\": \"https://umass-ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\","
                                               "\"cas_proxy_receive_url\": \"https://umass-ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\""
                                           "}"
                                           "]"
                                "},"
                                "{"
                                    "\"name\": \"Jefferson County\","
                                    "\"logo_url\": \"http://download.nubic.northwestern.edu/ncs_navigator_locations/images/jefferson_county.jpg\","
                                    "\"environments\": ["
                                           "{"
                                               "\"name\": \"staging\","
                                               "\"cases_url\": \"https://training-navcases.nubic.northwestern.edu\","
                                               "\"cas_base_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas\","
                                               "\"cas_proxy_retrieve_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\","
                                               "\"cas_proxy_receive_url\": \"https://ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\""
                                           "},"
                                           "{"
                                               "\"name\": \"production\","
                                               "\"cases_url\": \"https://uofl-navcases-staging.nubic.northwestern.edu\","
                                               "\"cas_base_url\": \"https://uofl-ncscas-staging.nubic.northwestern.edu/cas\","
                                               "\"cas_proxy_retrieve_url\": \"https://uofl-ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/receive_pgt\","
                                               "\"cas_proxy_receive_url\": \"https://uofl-ncscas-staging.nubic.northwestern.edu/cas-proxy-callback/retrieve_pgt\""
                                           "}"
                                           "]"
                                "}"
                                "]"
                    "}";
    self.dataDictionary = [NSJSONSerialization JSONObjectWithData:[self.dataString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    self.endpointArray = @[];
    for (NSDictionary *locationDictionary in self.dataDictionary[@"locations"]) {
        NUEndpoint *newEndpoint = [[NUEndpoint alloc] initWithDataDictionary:locationDictionary];
        self.endpointArray = [self.endpointArray arrayByAddingObject:newEndpoint];
    }
}

-(void)testEndpointValues {
    for (NSDictionary *endpointDictionary in self.dataDictionary[@"locations"]) {
        NSString *nameString = endpointDictionary[@"name"];
        NUEndpoint *endpoint = [[self.endpointArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", nameString]] lastObject];
        STAssertTrue([endpointDictionary[@"name"] isEqualToString:endpoint.name], @"endpoint name not the same as dictionary");
        STAssertTrue([endpointDictionary[@"logo_url"] isEqualToString:endpoint.imageURL.absoluteString], @"endpoint image url not the same as dictionary");
        for (NSDictionary *environmentDictionary in endpointDictionary[@"environments"]) {
            NUEndpointEnvironment *environment = [[endpoint.environmentArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", environmentDictionary[@"name"]]] lastObject];
            STAssertTrue([environmentDictionary[@"name"] isEqualToString:environment.name], @"environment name not the same as dictionary");
            STAssertTrue([environmentDictionary[@"cases_url"] isEqualToString:environment.coreURL.absoluteString], @"environment coreURL not the same as dictionary");
            STAssertTrue([environmentDictionary[@"cas_base_url"] isEqualToString:environment.casServerURL.absoluteString], @"environment casServerURL not the same as dictionary");
            STAssertTrue([environmentDictionary[@"cas_proxy_retrieve_url"] isEqualToString:environment.pgtRetrieveURL.absoluteString], @"environment pgtRetrieveURL not the same as dictionary");
            STAssertTrue([environmentDictionary[@"cas_proxy_receive_url"] isEqualToString:environment.pgtReceiveURL.absoluteString], @"environment pgtReceiveURL not the same as dictionary");
        }
    }
}


@end
