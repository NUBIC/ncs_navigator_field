//
//  InstrumentTest.m
//  NCSNavField
//
//  Created by John Dzak on 4/11/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "InstrumentTest.h"
#import "Instrument.h"
#import <CoreData.h>
#import <RestKit.h>

@implementation InstrumentTest

- (void)testSanity {
    Instrument* ins = [Instrument createInContext:self.ctx];
    ins.instrumentId = @"12345";
    [self.ctx save:nil];
    // BUG: Workaround for issue with findFirst
    //    Instrument* found = [Instrument findFirstByAttribute:@"instrumentId" withValue:@"12345" inContext:self.ctx];
    NSArray* found = [Instrument findByAttribute:@"instrumentId" withValue:@"12345" inContext:self.ctx];
    Instrument* i = [found objectAtIndex:0];
    STAssertEqualObjects(i.instrumentId, @"12345", @"Wrong id");
}


- (void)testSetResultSet {
    
}
@end