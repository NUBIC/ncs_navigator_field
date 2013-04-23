//
//  FieldworkPushStepTest.m
//  NCSNavField
//
//  Created by John Dzak on 4/19/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "FieldworkPushStepTest.h"
#import <Nocilla/Nocilla.h>
#import <OCMock/OCMock.h>
#import "CasServiceTicket.h"
#import "CasServiceTicket+Additions.h"
#import "CasProxyTicket.h"
#import "FieldworkPushStep.h"
#import "Fieldwork.h"
#import "Contact.h"
#import "JSONParserNSJSONSerialization.h"
#import "RestKitTestStub.h"
#import "FieldworkSynchronizationException.h"

@implementation FieldworkPushStepTest

static id serviceTicket;
static id proxyTicket;

- (void)setUp {
    [super setUp];
    
    [RestKitTestStub inject];
    
    serviceTicket = [OCMockObject mockForClass:[CasServiceTicket class]];
    proxyTicket = [OCMockObject mockForClass:[CasProxyTicket class]];
}
- (void)testSuccessfullPush {
    Fieldwork* f = [Fieldwork object];
    f.uri = @"http://field.test.local/api/v1/fieldwork/XYZ123";
    [Contact object];
    
    stubRequest(@"PUT", @"http://field.test.local/api/v1/fieldwork/XYZ123").
    withHeaders(@{
        @"Authorization": @"CasProxy PT-TEST-VALID",
        @"Content-Type": @"application/json",
        @"X-Client-ID": @"CID-TEST" });
    
    [[LSNocilla sharedInstance] start];
    
    serviceTicket = [OCMockObject mockForClass:[CasServiceTicket class]];
    proxyTicket = [OCMockObject mockForClass:[CasProxyTicket class]];
    
    FieldworkPushStep* step = [[FieldworkPushStep alloc] initWithServiceTicket:serviceTicket];
    
    [[[serviceTicket stub] andReturn:proxyTicket] obtainProxyTicket];
    [[[proxyTicket stub] andReturn:@"PT-TEST-VALID"] proxyTicket];
    
    [serviceTicket verify];
    [proxyTicket verify];
    
    STAssertTrue([step send], @"Should be successful");
}

- (void)testFailedPushWithNilServiceTicket {
    FieldworkPushStep* step = [[FieldworkPushStep alloc] initWithServiceTicket:nil];
    STAssertThrowsSpecific([step send], FieldworkSynchronizationException, nil);
}

- (void)testFailedPushWithNilProxyTicket {
    serviceTicket = [OCMockObject mockForClass:[CasServiceTicket class]];
        
    [[[serviceTicket stub] andReturn:nil] obtainProxyTicket];
    
    [serviceTicket verify];
    
    FieldworkPushStep* step = [[FieldworkPushStep alloc] initWithServiceTicket:serviceTicket];
    STAssertThrowsSpecific([step send], FieldworkSynchronizationException, nil);
}

@end
