//
//  PushFieldworkStep.m
//  NCSNavField
//
//  Created by John Dzak on 4/24/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "PushFieldworkStepTest.h"
#import "CasServiceTicket.h"
#import "RestKit.h"
//#import "PutFieldwork.h"

@implementation RKResponse(Stub)
- (BOOL)isSuccessful { return true; }
@end

@implementation RKRequest(Stub)
- (RKResponse*)sendSynchronously {
    return [RKResponse new];
}
@end

@implementation PushFieldworkStepTest

// iOS Cocoa HTTP server implementation
// http://stackoverflow.com/questions/5358493/mini-server-implementation-in-objective-c


//- (void)testPush {
//    CasServiceTicket* ticket = [CasServiceTicket new];
//    PushFieldworkStep* step = [[PushFieldworkStep alloc] initWithServiceTicket:ticket];
//    [step perform];
//    STAssertTrue([step isSuccessful], @"Should be true");
//}

// TODO: Add error handling
// TODO: Test against server

@end
