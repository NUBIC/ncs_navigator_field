//
//  RetrieveFieldworkStepTest.m
//  NCSNavField
//
//  Created by John Dzak on 4/17/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "FieldworkRetrieveStepTest.h"
#import "FieldworkRetrieveStep.h"
#import "RestKitSettings.h"
#import "JSONParserNSJSONSerialization.h"
#import "ApplicationSettings.h"
#import <RestKit/RestKit.h>
#import <OCMock/OCMock.h>
#import <Nocilla/Nocilla.h>
#import "Fixtures.h"
#import "CasServiceTicket.h"
#import "CasProxyTicket.h"
#import "CasServiceTicket+Additions.h"
#import "FieldworkSynchronizationException.h"
#import "RestKitTestStub.h"

@implementation ApplicationSettings (UnitTest)

- (NSString*) clientId {
    return @"CID-TEST";
}

@end

@implementation FieldworkRetrieveStepTest

static NSString* url;
static id serviceTicket;
static id proxyTicket;
static FieldworkRetrieveStep* step;
id dateMock;

- (void)setUp {
    [super setUp];

    dateMock = [OCMockObject mockForClass:[NSDate class]];
    [[[[dateMock stub] classMethod] andReturn:[Fixtures createDateFromString:@"2013-01-01"]] date];
    
    [RestKitTestStub inject];

    url = [NSString stringWithFormat:@"%@/api/v1/fieldwork?start_date=2013-01-01&end_date=2013-01-08", [RestKitTestStub baseURL]];

    serviceTicket = [OCMockObject mockForClass:[CasServiceTicket class]];
    proxyTicket = [OCMockObject mockForClass:[CasProxyTicket class]];
    
    step = [[FieldworkRetrieveStep alloc] initWithServiceTicket:serviceTicket];

    [[LSNocilla sharedInstance] start];
}

- (void)tearDown {
    [super tearDown];

    [dateMock stopMocking];

    [[LSNocilla sharedInstance] stop];
}

- (void)testSuccessfulRetrieve {
    stubRequest(@"POST", url).
        withHeaders(@{
            @"Authorization": @"CasProxy PT-TEST-VALID",
            @"Content-Length": @"0", @"X-Client-ID": @"CID-TEST" }).
        andReturn(201).
        withHeaders(@{@"Content-Type": @"application/json"}).
        withBody(@"{}");

    [[[serviceTicket stub] andReturn:proxyTicket] obtainProxyTicket];
    [[[proxyTicket stub] andReturn:@"PT-TEST-VALID"] proxyTicket];
        
    [serviceTicket verify];
    [proxyTicket verify];
    
    STAssertTrue([step send], @"Retrieval should be successful");
}

- (void)testFailedRetrieveWithInvalidProxyTicket {
    stubRequest(@"POST", url).
    withHeaders(@{
        @"Authorization": @"CasProxy PT-TEST-INVALID",
        @"Content-Length": @"0", @"X-Client-ID": @"CID-TEST" }).
    andReturn(401).
    withBody(@"Authorization Required");
    
    [[[serviceTicket stub] andReturn:proxyTicket] obtainProxyTicket];
    [[[proxyTicket stub] andReturn:@"PT-TEST-INVALID"] proxyTicket];
    
    [serviceTicket verify];
    [proxyTicket verify];
    
    STAssertThrowsSpecific([step send], FieldworkSynchronizationException, nil);
}

- (void)testFailedRetrieveWhenNilServiceTicket {
    FieldworkRetrieveStep* step = [[FieldworkRetrieveStep alloc] initWithServiceTicket:nil];
    STAssertThrowsSpecific([step send], FieldworkSynchronizationException, nil);
}

- (void)testFailedRetrieveWhenNilProxyTicket {
    [[[serviceTicket stub] andReturn:nil] obtainProxyTicket];

    [serviceTicket verify];
    
    STAssertThrowsSpecific([step send], FieldworkSynchronizationException, nil);
}

@end
