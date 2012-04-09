//
//  RestKitSettingsTest.m
//  NCSNavField
//
//  Created by John Dzak on 3/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "RestKitSettingsTest.h"
#import "RestKitSettings.h"
#import "FieldWork.h"
#import "RestKit.h"
#import "Contact.h"
#import "Event.h"
#import "Instrument.h"
#import "CoreData.h"
#import "MRCEnumerable.h"
#import "RestKitSettings.h"
#import "Fixtures.h"

@implementation RestKitSettingsTest

Instrument* i;
Event *e;
Contact* c;
FieldWork* f;

- (void)setUp {
    i = [Instrument object];
    i.name = @"INS A";
    
    e = [Event object];
    e.name = @"Birthday";
    e.instruments = [NSSet setWithObject:i];
    
    c = [Contact object];
    c.typeId = [NSNumber numberWithInt:22];
    c.events = [NSSet setWithObject:e];
    c.date = [Fixtures createDateFromString:@"2012-04-04 00:00"];
    c.startTime = [Fixtures createTimeFromString:@"10:45"];
    
    f = [FieldWork object];
    f.retrievedDate = [Fixtures createDateFromString:@"2012-04-1 00:00"];
    f.contacts = [NSSet setWithObject:c]; 
}

- (void)testSerializationMapping {
    [RestKitSettings instance];

    RKObjectMapping* fieldWorkMapping = [[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[FieldWork class]];
    RKObjectSerializer* serializer = [RKObjectSerializer serializerWithObject:f mapping:fieldWorkMapping];
    NSError* error = nil;
    
    NSMutableDictionary* actual = [serializer serializedObject:&error];
    
    // TODO: Participants and Instrument Templates should exist but empty
    
    NSDictionary* ac = [[[actual objectForKey:@"contacts"] objectEnumerator] nextObject];
    STAssertEquals(22, [[ac objectForKey:@"type"] integerValue], @"Wrong value");
    STAssertEqualObjects(@"2012-04-04", [ac objectForKey:@"contact_date"], @"Wrong value");
    STAssertEqualObjects(@"10:45", [ac objectForKey:@"start_time"], @"Wrong value");
    
    NSDictionary* ae = [[[ac objectForKey:@"events"] objectEnumerator] nextObject];
    STAssertEquals(@"Birthday", [ae objectForKey:@"name"], @"Wrong value");
    
    NSDictionary* ai = [[[ae objectForKey:@"instruments"] objectEnumerator] nextObject];
    STAssertEquals(@"INS A", [ai objectForKey:@"name"], @"Wrong value");
//    STAssertEquals(@"{survey:bla}", [ai objectForKey:@"response_set"], @"Wrong value");
}

@end
