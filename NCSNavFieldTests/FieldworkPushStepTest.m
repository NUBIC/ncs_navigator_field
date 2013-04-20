//
//  FieldworkPutRequestTest.m
//  NCSNavField
//
//  Created by John Dzak on 4/19/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "FieldworkPushStepTest.h"
#import <Nocilla/Nocilla.h>
#import "FieldworkPushStep.h"

@implementation FieldworkPushStepTest

- (void)testSuccessfullPush {
    [[LSNocilla sharedInstance] start];
    
    FieldworkPushStep* step = [[FieldworkPushStep alloc] initWithServiceTicket:nil];
    
    STAssertTrue([step send], @"Should be successful");
}

@end
