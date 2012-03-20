//
//  RestKitSettingsTest.m
//  NCSMobile
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
    e = [Event object];
    e.name = @"Birthday Party";
    
    c = [Contact object];
    c.typeId = [NSNumber numberWithInt:22];
    c.events = [NSSet setWithObject:e]; 
    
    f = [FieldWork object];
    f.retreivedDate = [Fixtures createDateFromString:@"2012-04-1 00:00"];
    f.identifier = @"Foo";
    f.contacts = [NSSet setWithObject:c]; 
}

- (void)testBasicFieldWorkMapping {
    RKObjectMapping* contactMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [contactMapping mapAttributes:@"typeId", nil];

    RKObjectMapping* fieldWorkMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class] ];
    [fieldWorkMapping mapAttributes:@"identifier", nil];
    [fieldWorkMapping mapRelationship:@"contacts" withMapping:contactMapping];
    
    RKObjectSerializer* serializer = [RKObjectSerializer serializerWithObject:f mapping:fieldWorkMapping];
    NSError* error = nil;
    
    // Turn an object into a dictionary
    NSMutableDictionary* serialized = [serializer serializedObject:&error];
    
    NSSet* actual = [serialized objectForKey:@"contacts"];
    STAssertFalse([actual empty], @"Should not be empty");
}

- (void)testFullMapping {
    [RestKitSettings instance];

    RKObjectMapping* fieldWorkMapping = [[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[FieldWork class]];
    RKObjectSerializer* serializer = [RKObjectSerializer serializerWithObject:f mapping:fieldWorkMapping];
    NSError* error = nil;
    
    NSMutableDictionary* actual = [serializer serializedObject:&error];
    
    NSDictionary* ac = [[[actual objectForKey:@"contacts"] objectEnumerator] nextObject];
    STAssertEquals(22, [[ac objectForKey:@"type"] integerValue], @"Wrong value");
}

@end
