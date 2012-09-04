//
//  RestKitSettings.m
//  NCSNavField
//
//  Created by John Dzak on 3/6/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "RestKitSettings.h"
#import "ApplicationSettings.h"
#import "Event.h"
#import "Person.h"
#import "Instrument.h"
#import "Participant.h"
#import "ResponseSet.h"
#import "Contact.h"
#import "Fieldwork.h"
#import "InstrumentTemplate.h"
#import "ApplicationSettings.h"
#import "NSDate+Additions.m"
#import "NSString+Additions.m"

NSString* STORE_NAME = @"main.sqlite";

@implementation RestKitSettings

static RestKitSettings* instance;

@synthesize baseServiceURL = _baseServiceURL;
@synthesize objectStoreFileName = _objectStoreFileName;

+ (RestKitSettings*) instance {
    instance = [[[RestKitSettings alloc] init] autorelease];
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _baseServiceURL = [[ApplicationSettings instance].coreURL retain];
        _objectStoreFileName = [STORE_NAME retain];
    }
    return self;
}

- (id)initWithBaseServiceURL:(NSString*)url objectStoreFileName:(NSString*)file {
    self = [super init];
    if (self) {
        _baseServiceURL = [url retain];
        _objectStoreFileName = [file retain];
    }
    return self;
}

+ (void)reload {
    RestKitSettings* s = [RestKitSettings instance];
    s.baseServiceURL = [ApplicationSettings instance].coreURL;
    [RKObjectManager sharedManager].client = [[RKClient alloc] initWithBaseURLString:s.baseServiceURL];

//    [RKObjectManager sharedManager].client.baseURL = [[RKURL alloc] initWithString:s.baseServiceURL];
}

- (void)introduce {    
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:self.baseServiceURL]];

    // Initialize store
    RKManagedObjectStore* objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:self.objectStoreFileName usingSeedDatabaseName:nil managedObjectModel:nil delegate:self];
    objectManager.objectStore = objectStore;
    
    // Setup Data Protection
    // iOS 4 encryption
    NSError *error = nil;
    if([self RSRunningOnOS4OrBetter]){
        NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
        if(![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:objectStore.pathToStoreFile error:&error]){
            NCSLog(@"Data protection is not enabled for %@", objectStore.pathToStoreFile);
        }
    }
    
    [self addMappingsToObjectManager: objectManager];
    
    RKObjectRouter* router = [[RKObjectRouter new] autorelease];
    [router routeClass:[Fieldwork class] toResourcePath:@"/api/v1/fieldwork/:fieldworkId"];
    [RKObjectManager sharedManager].router = router;
    
    [RKObjectManager sharedManager].acceptMIMEType = RKMIMETypeJSON;
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [self addSerializationMappingsToObjectManager:objectManager];

    // Enable automatic network activity indicator management
//    [RKClient sharedClient].showsNetworkActivityIndicatorWhenBusy = YES;
}

- (void)addMappingsToObjectManager:(RKObjectManager *)objectManager  {
    // Instrument Template
    RKManagedObjectMapping* instrumentTemplate = [RKManagedObjectMapping mappingForClass:[InstrumentTemplate class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    [instrumentTemplate setPrimaryKeyAttribute:@"instrumentTemplateId"];
    [instrumentTemplate mapKeyPathsToAttributes:
     @"instrument_template_id", @"instrumentTemplateId",
     @"representation", @"representation", nil];
    [instrumentTemplate setPrimaryKeyAttribute:@"instrumentTemplateId"];
    [objectManager.mappingProvider setMapping:instrumentTemplate forKeyPath:@"instrument_templates"];
    
    // Instrument Mapping
    RKManagedObjectMapping* instrument = [RKManagedObjectMapping mappingForClass:[Instrument class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    [instrument setPrimaryKeyAttribute:@"instrumentId"];
    [instrument mapKeyPathsToAttributes: 
     @"instrument_id", @"instrumentId",
     @"instrument_template_id", @"instrumentTemplateId",
     @"response_set", @"responseSetDict",
     @"name", @"name",
     @"instrument_type_code", @"instrumentTypeId", 
     @"instrument_type_other", @"instrumentTypeOther",
     @"instrument_version", @"instrumentVersion",
     @"instrument_repeat_key", @"repeatKey",
     @"instrument_start_date", @"startDate",
     @"instrument_start_time", @"startTimeJson",
     @"instrument_end_date", @"endDate",
     @"instrument_end_time", @"endTimeJson",
     @"instrument_status_code", @"statusId",
     @"instrument_breakoff_code", @"breakOffId",
     @"instrument_mode_code", @"instrumentModeId",
     @"instrument_mode_other", @"instrumentModeOther",
     @"instrument_method_code", @"instrumentMethodId",
     @"supervisor_review_code", @"supervisorReviewId",
     @"data_problem_code", @"dataProblemId",
     @"instrument_comment", @"comment", nil];
    [instrument mapRelationship:@"instrumentTemplate" withMapping:instrumentTemplate];
    [instrument connectRelationship:@"instrumentTemplate" withObjectForPrimaryKeyAttribute:@"instrumentTemplateId"];
    
    // Event Mapping
    RKManagedObjectMapping* event = [RKManagedObjectMapping mappingForClass:[Event class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    [event setPrimaryKeyAttribute:@"eventId"];
    [event mapKeyPathsToAttributes:
     @"event_id", @"eventId",
     @"version", @"version",
     @"name", @"name",
     @"event_type_code", @"eventTypeId",
     @"event_type_other", @"eventTypeOther",
     @"event_repeat_key", @"repeatKey",
     @"event_start_date", @"startDate",
     @"event_end_date", @"endDate",
     @"event_start_time", @"startTimeJson",
     @"event_end_time", @"endTimeJson",
     @"event_incentive_type_code", @"incentiveTypeId",
     @"event_incentive_cash", @"incentiveCash",
     @"event_disposition", @"dispositionId",
     @"event_disposition_category_code", @"dispositionCategoryId",
     @"event_breakoff_code", @"breakOffId",
     @"event_comment", @"comments", nil];
    [event mapRelationship:@"instruments" withMapping:instrument];
    
    // Person Mapping
    RKManagedObjectMapping* person = [RKManagedObjectMapping mappingForClass:[Person class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    [person setPrimaryKeyAttribute:@"personId"];
    [person mapKeyPathsToAttributes: 
     @"person_id", @"personId",
     @"name", @"name",
     @"home_phone", @"homePhone",
     @"cell_phone", @"cellPhone",
     @"email", @"email", 
     @"street", @"street",
     @"city", @"city",
     @"state", @"state",
     @"zip_code", @"zipCode", nil];
    [person setPrimaryKeyAttribute:@"personId"];
    [objectManager.mappingProvider setMapping:person forKeyPath:@"persons"];
    
    // Partipant Mapping
    RKManagedObjectMapping* participant = [RKManagedObjectMapping mappingForClass:[Participant class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    [participant setPrimaryKeyAttribute:@"pId"];
    [participant mapKeyPathsToAttributes:
     @"p_id", @"pId", nil];
    [participant mapRelationship:@"persons" withMapping:person];
    [objectManager.mappingProvider setMapping:participant forKeyPath:@"participants"];

    // Contact Mapping
    RKManagedObjectMapping* contact = [RKManagedObjectMapping mappingForClass:[Contact class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    [contact setPrimaryKeyAttribute:@"contactId"];
    [contact mapKeyPathsToAttributes:
     @"contact_id", @"contactId",
     @"contact_type_code", @"typeId",
     @"version", @"version",
     @"contact_date_date", @"date",
     @"contact_start_time", @"startTimeJson",
     @"contact_end_time", @"endTimeJson",
     @"person_id", @"personId", 
     @"contact_location_code", @"locationId",
     @"contact_location_other", @"locationOther",
     @"who_contacted_code", @"whoContactedId",
     @"who_contacted_other", @"whoContactedOther",
     @"contact_comment", @"comments", 
     @"contact_language_code", @"languageId",
     @"contact_language_other", @"languageOther",
     @"contact_interpret_code", @"interpreterId",
     @"contact_interpret_other", @"interpreterOther",
     @"contact_private_code", @"privateId",
     @"contact_private_detail", @"privateDetail",
     @"contact_distance", @"distanceTraveled",
     @"contact_disposition", @"dispositionId", nil];
    [contact mapRelationship:@"person" withMapping:person];
    [contact connectRelationship:@"person" withObjectForPrimaryKeyAttribute:@"personId"];
    [contact mapRelationship:@"events" withMapping:event];
    [objectManager.mappingProvider setMapping:contact forKeyPath:@"contacts"];
    
    RKManagedObjectMapping* fieldWork = [RKManagedObjectMapping mappingForClass:[Fieldwork class] inManagedObjectStore:[RKObjectManager sharedManager].objectStore];
    [fieldWork mapRelationship:@"participants" withMapping:participant];
    [fieldWork mapRelationship:@"contacts" withMapping:contact];
    [fieldWork mapRelationship:@"instrumentTemplate" withMapping:instrumentTemplate];
    [objectManager.mappingProvider setMapping:fieldWork forKeyPath:@"field_work"];
    
    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy'-'MM'-'dd" inTimeZone:[NSTimeZone localTimeZone]];
//    [RKManagedObjectMapping addDefaultDateFormatterForString:@"hh':'mm':'ss" inTimeZone:[NSTimeZone localTimeZone]];


//    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy'-'MM'-'dd'T'HH':'mm'Z'" inTimeZone:nil];
//    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mm:ssZZ" inTimeZone:nil]; 
//    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mmZZ" inTimeZone:nil]; 
//    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mmZ" inTimeZone:nil]; 
}

- (void)addSerializationMappingsToObjectManager:(RKObjectManager*)objectManager {
    // Instrument Mapping
    RKManagedObjectMapping* instrument = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [instrument mapKeyPathsToAttributes: 
     @"instrumentId", @"instrument_id",
     @"responseSet.toDict", @"response_set",
     @"instrumentTemplateId", @"instrument_template_id",
     @"name", @"name", 
     @"instrumentTypeId", @"instrument_type_code", 
     @"instrumentTypeOther", @"instrument_type_other",
     @"instrumentVersion", @"instrument_version",
     @"repeatKey", @"instrument_repeat_key",
     @"startDate.jsonSchemaDate", @"instrument_start_date",
     @"startTime.jsonSchemaTime", @"instrument_start_time",
     @"endDate.jsonSchemaDate", @"instrument_end_date",
     @"endTime.jsonSchemaTime", @"instrument_end_time",
     @"statusId", @"instrument_status_code",
     @"breakOffId", @"instrument_breakoff_code",
     @"instrumentModeId", @"instrument_mode_code",
     @"instrumentModeOther", @"instrument_mode_other",
     @"instrumentMethodId", @"instrument_method_code",
     @"supervisorReviewId", @"supervisor_review_code",
     @"dataProblemId", @"data_problem_code",
     @"comment", @"instrument_comment",
     nil];
    [objectManager.mappingProvider setSerializationMapping:instrument forClass:[Instrument class]];
    
    // Event Mapping
    RKManagedObjectMapping* event = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [event mapKeyPathsToAttributes:
     @"eventId", @"event_id",
     @"name", @"name", 
     @"eventTypeId", @"event_type_code",
     @"eventTypeOther", @"event_type_other",
     @"repeatKey", @"event_repeat_key",
     @"startDate.jsonSchemaDate", @"event_start_date",
     @"endDate.jsonSchemaDate", @"event_end_date",
     @"startTime.jsonSchemaTime", @"event_start_time",
     @"endTime.jsonSchemaTime", @"event_end_time",
     @"incentiveTypeId", @"event_incentive_type_code",
     @"incentiveCash", @"event_incentive_cash",
     @"dispositionId", @"event_disposition",
     @"dispositionCategoryId", @"event_disposition_category_code",
     @"breakOffId", @"event_breakoff_code",
     @"comments", @"event_comment",
     @"version", @"version", nil];
    [event mapRelationship:@"instruments" withMapping:instrument];
    [objectManager.mappingProvider setSerializationMapping:event forClass:[Event class]];

    RKManagedObjectMapping* contact = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [contact mapKeyPathsToAttributes:
     @"contactId", @"contact_id", 
     @"typeId", @"contact_type_code",
     @"date.jsonSchemaDate", @"contact_date_date",
     @"startTime.jsonSchemaTime", @"contact_start_time",
     @"endTime.jsonSchemaTime", @"contact_end_time",
     @"personId", @"person_id",
     @"locationId", @"contact_location_code",
     @"locationOther", @"contact_location_other", 
     @"whoContactedId", @"who_contacted_code", 
     @"whoContactedOther", @"who_contacted_other", 
     @"comments", @"contact_comment", 
     @"languageId", @"contact_language_code", 
     @"languageOther", @"contact_language_other", 
     @"interpreterId", @"contact_interpret_code", 
     @"interpreterOther", @"contact_interpret_other", 
     @"privateId", @"contact_private_code", 
     @"privateDetail", @"contact_private_detail", 
     @"distanceTraveled", @"contact_distance", 
     @"dispositionId", @"contact_disposition",
     @"version", @"version", nil];
    [contact mapRelationship:@"events" withMapping:event];
    [objectManager.mappingProvider setSerializationMapping:contact forClass:[Contact class]];
    
//    
//    // Partipant Mapping
//    RKManagedObjectMapping* participant = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
//    [participant setPrimaryKeyAttribute:@"pId"];
//    [participant mapKeyPathsToAttributes:
//     @"p_id", @"pId", nil];
//    [objectManager.mappingProvider setMapping:participant forKeyPath:@"participants"];
//    
//    RKManagedObjectMapping* instrumentTemplate = [RKManagedObjectMapping mappingForClass:[NSMutableDictionary class]];
//    [instrumentTemplate setPrimaryKeyAttribute:@"instrumentTemplateId"];
//    [instrumentTemplate mapKeyPathsToAttributes:
//     @"instrument_template_id", @"instrumentTemplateId", nil];
//    [instrumentTemplate setPrimaryKeyAttribute:@"instrumentTemplateId"];
//    [objectManager.mappingProvider setMapping:instrumentTemplate forKeyPath:@"instrument_templates"];
//    
//    
    RKObjectMapping* fieldWorkMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class] ];
//    [fieldWorkMapping mapKeyPathsToAttributes:@"fieldworkId", @"identifier", nil];
    [fieldWorkMapping mapRelationship:@"contacts" withMapping:contact];
     [fieldWorkMapping mapKeyPath:@"emptyArray" toAttribute:@"instrument_templates"];
      [fieldWorkMapping mapKeyPath:@"emptyArray" toAttribute:@"participants"];
    
    [objectManager.mappingProvider setSerializationMapping:fieldWorkMapping forClass:[Fieldwork class]];

}

#pragma mark - Core Data stack
- (BOOL) RSRunningOnOS4OrBetter {
    static BOOL didCheckIfOnOS4 = NO;
    static BOOL runningOnOS4OrBetter = NO;
    return runningOnOS4OrBetter;
    
    if(!didCheckIfOnOS4){
        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        NSInteger majorSystemVersion = 3;
        if(systemVersion != nil && [systemVersion length] > 0){
            NSString *firstCharacter = [systemVersion substringToIndex:1];
            majorSystemVersion = [firstCharacter integerValue];
        }
        
        runningOnOS4OrBetter = (majorSystemVersion >= 4);
        didCheckIfOnOS4 = YES;
    }
    
    return runningOnOS4OrBetter;
}


- (void)dealloc {
    [_baseServiceURL release];
    [_objectStoreFileName release];
    [super dealloc];
}

@end
