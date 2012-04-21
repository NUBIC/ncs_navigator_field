//
//  RestKitSettingsTest.m
//  NCSNavField
//
//  Created by John Dzak on 3/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "RestKitSettingsTest.h"
#import "RestKitSettings.h"
#import "Fieldwork.h"
#import "RestKit.h"
#import "Contact.h"
#import "Event.h"
#import "Instrument.h"
#import "CoreData.h"
#import "MRCEnumerable.h"
#import "RestKitSettings.h"
#import "Fixtures.h"
#import "SBJSON.h"
#import "NUResponseSet.h"
#import "NSDate+Additions.h"

@implementation RestKitSettingsTest


- (void)setUp {
}

- (Fieldwork *)fieldworkTestData {
    NSManagedObjectModel* mom = [RKObjectManager sharedManager].objectStore.managedObjectModel;
    NSEntityDescription *entity =
    [[mom entitiesByName] objectForKey:@"ResponseSet"];
    NUResponseSet *rs = [[NUResponseSet alloc]
                         initWithEntity:entity insertIntoManagedObjectContext:[NUResponseSet managedObjectContext]];

    [rs setValue:@"RS A" forKey:@"uuid"];
    
    Instrument* i = [Instrument object];
    i.name = @"INS A";
    i.responseSet = rs;
    
    Event* e = [Event object];
    e.name = @"Birthday";
    e.instruments = [NSSet setWithObject:i];
    
    Contact* c = [Contact object];
    c.typeId = [NSNumber numberWithInt:22];
    c.events = [NSSet setWithObject:e];
    c.date = [Fixtures createDateFromString:@"2012-04-04"];
    c.startTime = [Fixtures createTimeFromString:@"10:45"];
    
    Fieldwork* f = [Fieldwork object];
    f.retrievedDate = [Fixtures createDateFromString:@"2012-04-1"];
    f.contacts = [NSSet setWithObject:c];
    return f;
}

- (void)testSerializationMapping {
    [RestKitSettings instance];

    Fieldwork* f = [self fieldworkTestData]; 
    

    RKObjectMapping* fieldWorkMapping = [[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[Fieldwork class]];
    RKObjectSerializer* serializer = [RKObjectSerializer serializerWithObject:f mapping:fieldWorkMapping];
    NSError* error = nil;
    
    NSMutableDictionary* actual = [serializer serializedObject:&error];
    
    // TODO: Participants and Instrument Templates should exist but empty
    
    NSDictionary* ac = [[[actual objectForKey:@"contacts"] objectEnumerator] nextObject];
    STAssertEquals(22, [[ac objectForKey:@"type"] integerValue], @"Wrong value");
    STAssertEqualObjects(@"2012-04-04", [ac objectForKey:@"contact_date"], @"Wrong value");
    STAssertEqualObjects(@"10:45", [ac objectForKey:@"start_time"], @"Wrong value");
    
    NSDictionary* ae = [[[ac objectForKey:@"events"] objectEnumerator] nextObject];
    STAssertEqualObjects(@"Birthday", [ae objectForKey:@"name"], @"Wrong value");
    
    NSDictionary* ai = [[[ae objectForKey:@"instruments"] objectEnumerator] nextObject];
    STAssertEqualObjects(@"INS A", [ai objectForKey:@"name"], @"Wrong value");
    STAssertEqualObjects(@"RS A", [[ai objectForKey:@"response_set"] valueForKey:@"uuid"], @"Wrong value");
}



- (void)testGeneralDeserialization { 
    NSString* fieldworkJson = 
        @"{                                         "
         "  \"contacts\":[                          "
         "    {                                     "
         "      \"contact_id\":\"c1\",              "
         "      \"date\":\"2009-03-07\",             "
         "      \"events\":[                        "
         "        {                                 "
         "          \"event_id\":\"e1\"             "
         "          \"instruments\":[               "
         "            {                             "
         "               \"instrument_id\":\"i1\"   "
         "               \"response_set\":{         "
         "                 \"uuid\":\"rs1\",         "
         "                 \"responses\":[          "
         "                   {\"uuid\":\"r1\"}      "
         "                   {\"uuid\":\"r2\"}      "
         "                 ]                        "
         "               }                          "
         "            }                             "
         "          ]                               "
         "        }                                 "
         "      ]                                   "
         "    }                                     "
         "  ],                                      "
         "  \"instrument_templates\":[]             "
         "}                                         ";
    
    NSDictionary* actual = [self deserializeJson:fieldworkJson];
    
    Contact* ct = [[actual objectForKey:@"contacts"] objectAtIndex:0];
    STAssertEqualObjects(ct.contactId, @"c1", @"Wrong value");
    STAssertEqualObjects([ct.date jsonSchemaDate], @"2009-03-07", @"Wrong date");
    
    Event* et = [[ct.events objectEnumerator] nextObject];
    STAssertEqualObjects(et.eventId, @"e1", @"Wrong value");
    
    Instrument* it = [[et.instruments objectEnumerator] nextObject];
    STAssertEqualObjects(it.instrumentId, @"i1", @"Wrong value");
    STAssertEqualObjects(it.externalResponseSetId, @"rs1", @"Wrong value");
    
    NUResponseSet* rs = it.responseSet;
    STAssertEqualObjects([rs valueForKey:@"uuid"], @"rs1", @"Wrong value");
}

#pragma mark - Helper Methods
 
 - (NSDictionary *)deserializeJson:(NSString *)fieldworkJson {
    NSDictionary* fieldwork = [[SBJSON new] objectWithString:fieldworkJson];
    RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:fieldwork mappingProvider:[RKObjectManager sharedManager].mappingProvider];
    RKObjectMappingResult* result = [mapper performMapping];
    return [result asDictionary];
}

@end
