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
#import "ResponseSet.h"
#import "NSDate+Additions.h"
#import "InstrumentPlan.h"
#import "InstrumentTemplate.h"
#import "EventTemplate.h"
#import "Provider.h"
#import "Participant.h"
#import "ResponseTemplate.h"
#import "MdesCode.h"
#import "DispositionCode.h"
#import <MRCEnumerable/MRCEnumerable.h>
#import <JSONKit/JSONKit.h>
#import "NUAnswer.h"
#import "NUQuestion.h"
#import "Response.h"

@implementation RestKitSettingsTest

- (Fieldwork *)fieldworkTestData {
    ResponseSet *rs = [ResponseSet object];
    [rs setValue:@"RS A" forKey:@"uuid"];
    
    Instrument* i = [Instrument object];
    i.name = @"INS A";
    i.instrumentPlanId = @"IP A";
    i.responseSets = [NSSet setWithObjects:rs, nil];
    
    Event* e = [Event object];
    e.name = @"Birthday";
    e.dispositionCode = @"4";
    e.instruments = [NSOrderedSet orderedSetWithObject:i];
    
    Contact* c = [Contact object];
    c.typeId = [NSNumber numberWithInt:22];
    c.events = [NSSet setWithObject:e];
    c.date = [Fixtures createDateFromString:@"2012-04-04"];
    c.startTime = [Fixtures createTimeFromString:@"10:45"];
    
    Fieldwork* f = [Fieldwork object];
    f.retrievedDate = [Fixtures createDateFromString:@"2012-04-1"];
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
    STAssertEqualObjects(@4, [ae objectForKey:@"event_disposition"], @"Wrong value");
    
    NSDictionary* ai = [[[ae objectForKey:@"instruments"] objectEnumerator] nextObject];
    STAssertEqualObjects(@"INS A", [ai objectForKey:@"name"], @"Wrong value");
    STAssertEqualObjects(@"IP A", [ai valueForKey:@"instrument_plan_id"], @"Wrong value");
    
    NSArray *rs = [ai objectForKey:@"response_sets"];
    STAssertEqualObjects(@"RS A", [[[rs objectEnumerator] nextObject] valueForKey:@"uuid"], @"Wrong value");
}

- (void)testParticipantSerializationMapping {
    [RestKitSettings instance];
    
    [Fixtures createParticipantWithId:@"abc" person:[Fixtures createPersonWithId:@"xyz" name:@"Frank"]];
    Fieldwork* f = [Fieldwork object];
    
    RKObjectMapping* fieldWorkMapping = [[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[Fieldwork class]];
    RKObjectSerializer* serializer = [RKObjectSerializer serializerWithObject:f mapping:fieldWorkMapping];
    NSError* error = nil;
    
    NSMutableDictionary* actual = [serializer serializedObject:&error];
    
    NSDictionary* participants = [actual objectForKey:@"participants"];
    NSDictionary* participant = [[participants objectEnumerator] nextObject];
    STAssertEqualObjects([participant valueForKey:@"p_id"], @"abc", nil);
    NSDictionary* person = [[[participant valueForKey:@"persons"] objectEnumerator] nextObject];
    STAssertEqualObjects([person valueForKey:@"first_name"], @"Frank", nil);
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
         "          \"event_disposition\":4,            "
         "          \"instruments\":[                   "
         "            {                                 "
         "               \"instrument_id\":\"i1\",       "
         "               \"response_sets\":[{           "
         "                 \"uuid\":\"rs1\",            "
         "                 \"responses\":[              "
         "                   {\"uuid\":\"r1\"},          "
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
    STAssertEqualObjects(et.dispositionCode, @"4", @"Wrong value");
    
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

- (void)testParticipantsDeserialization {
    NSString* json =
    @"{ "
    "   \"participants\": [{                "
    "     \"p_id\": \"abc\",                "
    "     \"persons\":[{                    "
    "       \"first_name\": \"Frank\"       "
    "     }]                                "
    "   }]                                  "
    "}                                      ";
    
    NSDictionary* actual = [self deserializeJson:json];
    Participant* p = [[actual objectForKey:@"participants"] objectAtIndex:0];
    STAssertEqualObjects(p.pId, @"abc", @"Wrong value");
}
- (void)testEventTemplateDeserialization {
    [RestKitSettings instance];
    NSString* json =
        @"{ "
         "   \"event_templates\": [{             "
         "     \"name\": \"Pregnancy Screener\", "
         "     \"event_repeat_key\": 0,          "
         "     \"event_type_code\": 34,          "
         "     \"response_templates\": [         "
         "       { \"qref\": \"one\" }           "
         "     ],                                "
         "     \"instruments\":[{                "
         "          \"name\": \"Preg Scr Ins\"   "
         "      }]                               "
         "   }]                                  "
         "}                                      ";
    
    NSArray* actual = [[self deserializeJson:json] objectForKey:@"event_templates"];
    
    STAssertEquals([actual count], 1U, @"Should have 1 event template");
    EventTemplate* et = [actual objectAtIndex:0];
    STAssertEqualObjects(et.name, @"Pregnancy Screener", @"Wrong name");
    STAssertEqualObjects(et.eventRepeatKey, [NSNumber numberWithInt:0], @"Wrong repeat key");
    STAssertEqualObjects(et.eventTypeCode, [NSNumber numberWithInt:34], @"Wrong type code");
    ResponseTemplate* rt = [[[et responseTemplates] objectEnumerator] nextObject];
    STAssertEqualObjects(rt.qref, @"one", nil);
    Instrument* ins = [[[et instruments] objectEnumerator] nextObject];
    STAssertEqualObjects(ins.name, @"Preg Scr Ins", @"Wrong name");
}

- (void)testProviderDeserialization {
    [RestKitSettings instance];
    NSString* json =
        @"{ "
         "  \"providers\": [       "
         "    {\"name\": \"One\"}, "
         "    {\"name\": \"Two\"}  "
         "  ]                      "
         "}                        ";
    
    NSArray* actual = [[self deserializeJson:json] objectForKey:@"providers"];
    STAssertEquals([actual count], 2U, @"Should have 2 providers");
    STAssertEqualObjects(((Provider*)[actual objectAtIndex:0]).name, @"One", nil);
    STAssertEqualObjects(((Provider*)[actual objectAtIndex:1]).name, @"Two", nil);
}

-(void)testNcsCodeDeserialization {
    [RestKitSettings instance];
    NSString *js =
    @"{ \"ncs_codes\": [ "
        "{ \"list_name\" : \"ACCESS_ATTEMPT_CL1\", "
        "\"display_text\" : \"Not applicable\", "
        "\"local_code\" : -7 }, "
        " { \"list_name\" : \"ACCESS_ATTEMPT_CL1\","
        "\"display_text\" : \"Other\","
        "    \"local_code\" : -5"
        " } ] }";
    
    NSDictionary *dict = [self deserializeJson:js];
    NSArray *d1 = [dict objectForKey:@"ncs_codes"];
    STAssertEquals([d1 count], 2U, @"Should have 2 ncs codes");
    STAssertEqualObjects(((MdesCode*)[d1 objectAtIndex:0]).displayText, @"Not applicable", nil);
    STAssertEqualObjects(((MdesCode*)[d1 objectAtIndex:1]).displayText, @"Other", nil);
}

-(void)testDispositionCodeDeserialization {
    [RestKitSettings instance];
    
    NSString *j =
    @"{ "
    " \"disposition_codes\": [ "
    " {   \"final_category\" : \"Complete Screener\", "
    "    \"category_code\" : 8,"
    "    \"final_code\" : \"591\",   "
    "    \"interim_code\" : \"091\", "
    "    \"sub_category\" : \"Partial- Unable to Determine Eligibility - Other Language\","
    "    \"disposition\" : \"Partial with sufficient information in Other Language, but cannot determine eligibility\""
    " }, "
    " {   \"final_category\" : \"Complete Second Screen\", "
    "    \"category_code\" : 8,"
    "    \"final_code\" : \"590\","
    "    \"interim_code\" : \"090\","
    "    \"sub_category\" : \"Partial- Eligible - Other Language\","
    "    \"disposition\" : \"Partial with sufficient information in Other Language to determine eligible\""
    " } ] } ";
    
    NSDictionary *dict = [self deserializeJson:j];
    NSArray *d1 = [dict objectForKey:@"disposition_codes"];
    STAssertEquals([d1 count], 2U, @"Should have 2 disposition codes");
    STAssertEqualObjects(((DispositionCode*)[d1 objectAtIndex:0]).finalCategory, @"Complete Screener", nil);
    STAssertEqualObjects(((DispositionCode*)[d1 objectAtIndex:1]).finalCategory, @"Complete Second Screen", nil);
}

- (void)testResponseValueFloatSerialization {
    [RestKitSettings instance];
    
    NUAnswer* ans = [NUAnswer object];
    ans.uuid = @"ruff";
    ans.type = @"float";
    
    NUQuestion* qst = [NUQuestion object];
    qst.uuid = @"woof";
    qst.text = @"How many dogs?";
    [qst addAnswersObject:ans];
    
    
    Response* res = [Response object];
    [res setValue:@"woof" forKey:@"question"];
    [res setValue:@"ruff" forKey:@"answer"];
    [res setValue:@"3.13" forKey:@"value"];
    
    Instrument* i = [Instrument object];
    ResponseSet* rs = [ResponseSet object];
    rs.responses = [NSSet setWithObject:res];
    i.responseSets = [NSSet setWithObject:rs];
    
    
    RKObjectMapping* instrumentMapping = [[RKObjectManager sharedManager].mappingProvider serializationMappingForClass:[Instrument class]];
    RKObjectSerializer* serializer = [RKObjectSerializer serializerWithObject:i mapping:instrumentMapping];
    NSMutableDictionary* actual = [serializer serializedObject:nil];
    NSString* json = [serializer serializedObjectForMIMEType:RKMIMETypeJSON error:nil];
    NSLog(@"JSON: %@", json);
    
    // Response#value is being serialized to a number because we work around RestKit's implementation.
    // RKObjectSerializer normally serializes decimal attributes to strings, but because ResponseSet
    // is serialized outside of RestKit, RKObjectSerializer never checks the type for value Response#value
    // and it will remain a decimal. Also, the JSON serializer had to be changed to the one built into iOS
    // because JSONKit (RestKit's default JSON serializer) doesn't support decimal serialization.
    STAssertEqualObjects(actual[@"response_sets"][0][@"responses"][0][@"value"], @3.13, nil);
    STAssertTrue([json rangeOfString:@"\"value\" : 3.13"].location != NSNotFound, [NSString stringWithFormat:@"'\"value\" : 3.13' not found in json"]);
}

#pragma mark - Helper Methods
 
 - (NSDictionary *)deserializeJson:(NSString *)fieldworkJson {
     NSDictionary* fieldwork = [fieldworkJson objectFromJSONString];
     NSAssert(fieldwork != nil, @"Problem parsing fieldwork JSON");
     RKObjectMapper* mapper = [RKObjectMapper mapperWithObject:fieldwork mappingProvider:[RKObjectManager sharedManager].mappingProvider];
     RKObjectMappingResult* result = [mapper performMapping];
     return [result asDictionary];
}

@end
