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
#import "Contact.h"
#import "Event.h"
#import "Instrument.h"
#import "CoreData.h"
#import "MRCEnumerable.h"
#import "RestKitSettings.h"
#import "Fixtures.h"
#import "SBJSON.h"
#import "ResponseSet.h"
#import "NSDate+Additions.h"
#import "InstrumentPlan.h"
#import "InstrumentTemplate.h"
#import "EventTemplate.h"

@implementation RestKitSettingsTest


- (void)setUp {
}

- (Fieldwork *)fieldworkTestData {
    ResponseSet *rs = [ResponseSet object];
    [rs setValue:@"RS A" forKey:@"uuid"];
    
    Instrument* i = [Instrument object];
    i.name = @"INS A";
    i.instrumentPlanId = @"IP A";
    i.responseSets = [NSSet setWithObjects:rs, nil];
    
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
    STAssertEquals(22, [[ac objectForKey:@"contact_type_code"] integerValue], @"Wrong value");
    STAssertEqualObjects(@"2012-04-04", [ac objectForKey:@"contact_date_date"], @"Wrong value");
    STAssertEqualObjects(@"10:45", [ac objectForKey:@"contact_start_time"], @"Wrong value");
    
    NSDictionary* ae = [[[ac objectForKey:@"events"] objectEnumerator] nextObject];
    STAssertEqualObjects(@"Birthday", [ae objectForKey:@"name"], @"Wrong value");
    
    NSDictionary* ai = [[[ae objectForKey:@"instruments"] objectEnumerator] nextObject];
    STAssertEqualObjects(@"INS A", [ai objectForKey:@"name"], @"Wrong value");
    STAssertEqualObjects(@"IP A", [ai valueForKey:@"instrument_plan_id"], @"Wrong value");
    
    NSArray *rs = [ai objectForKey:@"response_sets"];
    STAssertEqualObjects(@"RS A", [[[rs objectEnumerator] nextObject] valueForKey:@"uuid"], @"Wrong value");
}



- (void)testGeneralDeserialization { 
    NSString* fieldworkJson = 
        @"{                                             "
         "  \"contacts\":[                              "
         "    {                                         "
         "      \"contact_id\":\"c1\",                  "
         "      \"contact_date_date\":\"2009-03-07\",   "
         "      \"contact_start_time\": \"10:28\",      "
         "      \"events\":[                            "
         "        {                                     "
         "          \"event_id\":\"e1\",                "
         "          \"instruments\":[                   "
         "            {                                 "
         "               \"instrument_id\":\"i1\"       "
         "               \"response_sets\":[{           "
         "                 \"uuid\":\"rs1\",            "
         "                 \"responses\":[              "
         "                   {\"uuid\":\"r1\"}          "
         "                   {\"uuid\":\"r2\"}          "
         "                 ]                            "
         "               }],                            "
         "               \"instrument_plan_id\":\"ip1\" "
         "            }                                 "
         "          ]                                   "
         "        }                                     "
         "      ]                                       "
         "    }                                         "
         "  ],                                          "
         "  \"instrument_plans\":[{                     "
         "    \"instrument_plan_id\":\"ip1\",           "
         "      \"instrument_templates\":[              "
         "        {                                     "
         "          \"instrument_template_id\":\"it1\", "
         "          \"participant_type\":\"mother\"     "
         "        },                                    "
         "        {                                     "
         "          \"instrument_template_id\":\"it2\", "
         "          \"participant_type\":\"child\"      "
         "        }                                     "
         "      ]                                       "
         "  }]                                          "
         "}                                             ";
    
    NSDictionary* actual = [self deserializeJson:fieldworkJson];
    
    Contact* ct = [[actual objectForKey:@"contacts"] objectAtIndex:0];
    STAssertEqualObjects(ct.contactId, @"c1", @"Wrong value");
    STAssertEqualObjects([ct.date jsonSchemaDate], @"2009-03-07", @"Wrong date");
    STAssertEqualObjects([ct.startTime jsonSchemaTime], @"10:28", @"Wrong time");
    
    Event* et = [[ct.events objectEnumerator] nextObject];
    STAssertEqualObjects(et.eventId, @"e1", @"Wrong value");
    
    Instrument* ins = [[et.instruments objectEnumerator] nextObject];
    STAssertEqualObjects(ins.instrumentId, @"i1", @"Wrong value");
    
    ResponseSet* rs = [[ins.responseSets objectEnumerator] nextObject];
    STAssertEqualObjects([rs valueForKey:@"uuid"], @"rs1", @"Wrong value");
    
    InstrumentPlan* ip = ins.instrumentPlan;
    STAssertEqualObjects([ip valueForKey:@"instrumentPlanId"], @"ip1", @"Wrong value");
    
    InstrumentTemplate* it1 = [ip.instrumentTemplates objectAtIndex:0];
    STAssertEqualObjects(it1.instrumentTemplateId, @"it1", @"Wrong id");
    InstrumentTemplate* it2 = [ip.instrumentTemplates objectAtIndex:1];
    STAssertEqualObjects(it2.instrumentTemplateId, @"it2", @"Wrong id");
}

- (void)testInstrumentTemplateDeserialization {
    NSString* json =
        @"{ "
         "   \"event_templates\": [{             "
         "     \"name\": \"Pregnancy Screener\", "
         "     \"event_repeat_key\": 0,          "
         "     \"event_type_code\": 34           "
         "   }]                                  "
         "}                                      ";
    
    NSArray* actual = [[self deserializeJson:json] objectForKey:@"event_templates"];
    
    STAssertEquals([actual count], 1U, @"Should have 1 event template");
    EventTemplate* et = [actual objectAtIndex:0];
    STAssertEqualObjects(et.name, @"Pregnancy Screener", @"Wrong name");
    STAssertEqualObjects(et.eventRepeatKey, [NSNumber numberWithInt:0], @"Wrong repeat key");
    STAssertEqualObjects(et.eventTypeCode, [NSNumber numberWithInt:34], @"Wrong type code");
}

#pragma mark - Helper Methods
 
 - (NSDictionary *)deserializeJson:(NSString *)fieldworkJson {
     NSDictionary* fieldwork = [[SBJSON new] objectWithString:fieldworkJson];
     NSAssert(fieldwork != nil, @"Problem parsing fieldwork JSON");
     RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:fieldwork mappingProvider:[RKObjectManager sharedManager].mappingProvider];
     RKObjectMappingResult* result = [mapper performMapping];
     return [result asDictionary];
}

@end
