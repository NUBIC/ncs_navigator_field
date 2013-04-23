//
//  CasServiceTicketTest.m
//  NCSNavField
//
//  Created by John Dzak on 4/22/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "CasServiceTicketTest.h"
#import "CasServiceTicket.h"
#import "CasServiceTicket+Additions.h"
#import "CasProxyTicket.h"
#import "CasTicketException.h"
#import <OCMock/OCMock.h>

@implementation CasServiceTicket (UnitTest)

static CasClient* casClientMock = nil;

- (CasClient*) casClient {
    return casClientMock;
}

- (void)setCasClientMock:(id)mock {
    casClientMock = mock;
}

@end

@implementation CasServiceTicketTest

id casClient;
id serviceTicket;
id proxyTicket;

- (void)setUp {
    [super setUp];
    casClient = [OCMockObject mockForClass:[CasClient class]];
    serviceTicket = [OCMockObject partialMockForObject:[CasServiceTicket new]];
    proxyTicket = [OCMockObject mockForClass:[CasProxyTicket class]];
    
    [serviceTicket setCasClientMock:casClient];
}

- (void)testObtainProxyTicketSuccess {
    [[[serviceTicket stub] andReturn:@"PGT-TEST-VALID"] pgt];

    [[[casClient stub] andReturn:proxyTicket] proxyTicket:[OCMArg any] serviceURL:[OCMArg any] proxyGrantingTicket:[OCMArg any]];
    
    [[proxyTicket expect] reify];
    
    [[[proxyTicket stub] andReturn:nil] error];

    STAssertNotNil([serviceTicket obtainProxyTicket], @"Should be successful");

    [serviceTicket verify];
    [casClient verify];
    [proxyTicket verify];
}

- (void)testObtainProxyTicketSuccessWhenValidateST {
    [[[serviceTicket stub] andReturn:nil] pgt];
    [[serviceTicket expect] present];
    [[[serviceTicket stub] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isOk];
    
    [[[casClient stub] andReturn:proxyTicket] proxyTicket:[OCMArg any] serviceURL:[OCMArg any] proxyGrantingTicket:[OCMArg any]];
    
    [[proxyTicket expect] reify];
    
    [[[proxyTicket stub] andReturn:nil] error];
    
    STAssertNotNil([serviceTicket obtainProxyTicket], @"Should be successful");
    
    [serviceTicket verify];
    [casClient verify];
    [proxyTicket verify];
}

- (void)testObtainProxyTicketFailWhenNoPgt {
    [[[serviceTicket stub] andReturn:nil] pgt];
    [[serviceTicket expect] present];
    [[[serviceTicket stub] andReturnValue:OCMOCK_VALUE((BOOL){NO})] isOk];
        
    STAssertThrowsSpecific([serviceTicket obtainProxyTicket], CasTicketException, nil);
    
    [serviceTicket verify];
}

- (void)testObtainProxyTicketFailWhenNoPT {
    [[[serviceTicket stub] andReturn:nil] pgt];
    [[serviceTicket expect] present];
    [[[serviceTicket stub] andReturnValue:OCMOCK_VALUE((BOOL){YES})] isOk];

    [[[casClient stub] andReturn:proxyTicket] proxyTicket:[OCMArg any] serviceURL:[OCMArg any] proxyGrantingTicket:[OCMArg any]];

    [[proxyTicket expect] reify];

    [[[proxyTicket stub] andReturn:@"Failure"] error];

    STAssertThrowsSpecific([serviceTicket obtainProxyTicket], CasTicketException, nil);

    [serviceTicket verify];
    [casClient verify];
    [proxyTicket verify];
}
@end
