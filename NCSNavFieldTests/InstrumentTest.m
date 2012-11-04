//
//  InstrumentTest.m
//  NCSNavField
//
//  Created by John Dzak on 4/11/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "InstrumentTest.h"
#import "Instrument.h"
#import "ResponseSet.h"

@implementation InstrumentTest

- (void)testSanity {
    Instrument* ins = [Instrument object];
    ins.instrumentId = @"12345";
    [[ins managedObjectContext] save:nil];
    Instrument* found = [Instrument findFirstByAttribute:@"instrumentId" withValue:@"12345"];
    STAssertEqualObjects(found.instrumentId, @"12345", @"Wrong id");
}

@end
