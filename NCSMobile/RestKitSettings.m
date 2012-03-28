//
//  RestKitSettings.m
//  NCSMobile
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
#import "NUResponseSet.h"
#import "Contact.h"
#import "FieldWork.h"
#import "InstrumentTemplate.h"
#import "ApplicationSettings.h"

NSString* STORE_NAME = @"main.sqlite";

@implementation RestKitSettings

static RestKitSettings* instance;

@synthesize baseServiceURL = _baseServiceURL;
@synthesize objectStoreFileName = _objectStoreFileName;

+ (RestKitSettings*) instance {
    instance = [[RestKitSettings alloc] init];
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _baseServiceURL = [ApplicationSettings instance].coreURL;
        _objectStoreFileName = STORE_NAME;
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
    [RKObjectManager sharedManager].client.baseURL = s.baseServiceURL;
}

- (void)introduce {    
    RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:self.baseServiceURL];

    // Initialize store
    RKManagedObjectStore* objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:self.objectStoreFileName usingSeedDatabaseName:nil managedObjectModel:nil delegate:self];
    objectManager.objectStore = objectStore;
    
    // Setup Data Protection
    // iOS 4 encryption
    NSError *error = nil;
    if([self RSRunningOnOS4OrBetter]){
        NSDictionary *fileAttributes = [NSDictionary dictionaryWithObject:NSFileProtectionComplete forKey:NSFileProtectionKey];
        if(![[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:objectStore.pathToStoreFile error:&error]){
            NSLog(@"Data protection is not enabled for %@", objectStore.pathToStoreFile);
        }
    }
    
    [self addMappingsToObjectManager: objectManager];
    
    RKObjectRouter* router = [RKObjectRouter new];
    [router routeClass:[FieldWork class] toResourcePath:@"/api/v1/fieldwork/:fieldWorkId"];
    [RKObjectManager sharedManager].router = router;
    
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [self addSerializationMappingsToObjectManager:objectManager];

    // Enable automatic network activity indicator management
//    [RKClient sharedClient].showsNetworkActivityIndicatorWhenBusy = YES;
}

- (void)addMappingsToObjectManager:(RKObjectManager *)objectManager  {
    // Instrument Template
    RKManagedObjectMapping* instrumentTemplate = [RKManagedObjectMapping mappingForClass:[InstrumentTemplate class]];
    [instrumentTemplate mapKeyPathsToAttributes:
     @"instrument_template_id", @"instrumentTemplateId",
     @"representation", @"representation", nil];
    [instrumentTemplate setPrimaryKeyAttribute:@"instrumentTemplateId"];
    [objectManager.mappingProvider setMapping:instrumentTemplate forKeyPath:@"instrument_templates"];
    
    // Instrument Mapping
    RKManagedObjectMapping* instrument = [RKManagedObjectMapping mappingForClass:[Instrument class]];
    [instrument mapKeyPathsToAttributes: 
     @"instrument_id", @"instrumentId",
     @"instrument_template_id", @"instrumentTemplateId",
     @"name", @"name", nil];
    [instrument mapRelationship:@"instrumentTemplate" withMapping:instrumentTemplate];
    [instrument connectRelationship:@"instrumentTemplate" withObjectForPrimaryKeyAttribute:@"instrumentTemplateId"];
    
    // Event Mapping
    RKManagedObjectMapping* event = [RKManagedObjectMapping mappingForClass:[Event class]];
    [event mapKeyPathsToAttributes:
     @"event_id", @"eventId",
     @"name", @"name", nil];
    [event mapRelationship:@"instruments" withMapping:instrument];
    
    // Person Mapping
    RKManagedObjectMapping* person = [RKManagedObjectMapping mappingForClass:[Person class]];
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
    RKManagedObjectMapping* participant = [RKManagedObjectMapping mappingForClass:[Participant class]];
    [participant mapKeyPathsToAttributes:
     @"p_id", @"pId", nil];
    [participant mapRelationship:@"persons" withMapping:person];
    [objectManager.mappingProvider setMapping:participant forKeyPath:@"participants"];

    // Contact Mapping
    RKManagedObjectMapping* contact = [RKManagedObjectMapping mappingForClass:[Contact class]];
    [contact mapKeyPathsToAttributes:
     @"contact_id", @"contactId",
     @"type", @"typeId",
     @"start_date", @"startDate",
     @"end_date", @"endDate",
     @"person_id", @"personId", nil];
    [contact mapRelationship:@"person" withMapping:person];
    [contact connectRelationship:@"person" withObjectForPrimaryKeyAttribute:@"personId"];
    [contact mapRelationship:@"events" withMapping:event];
    [objectManager.mappingProvider setMapping:contact forKeyPath:@"contacts"];
    [contact.dateFormatStrings addObject:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z"];
    [contact.dateFormatStrings addObject:@"yyyy'-'MM'-'dd'T'HH':'mm'Z'"];
    [contact.dateFormatStrings addObject:@"yyyy-MM-dd'T'hh:mm:ssZZ"]; 
    [contact.dateFormatStrings addObject:@"yyyy-MM-dd'T'hh:mmZZ"]; 
    [contact.dateFormatStrings addObject:@"yyyy-MM-dd'T'hh:mmZ"];
    
    RKManagedObjectMapping* fieldWork = [RKManagedObjectMapping mappingForClass:[FieldWork class]];
    [fieldWork mapRelationship:@"participants" withMapping:participant];
    [fieldWork mapRelationship:@"contacts" withMapping:contact];
    [fieldWork mapRelationship:@"instrumentTemplate" withMapping:instrumentTemplate];
    [objectManager.mappingProvider setMapping:fieldWork forKeyPath:@"field_work"];
    
    // TODO: Does this work?
    // "2005-07-16T19:20+01:00",
    // http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369
    // RestKit 0.9.4 date mappings
//    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy'-'MM'-'dd'T'HH':'mm'Z'" inTimeZone:nil];
//    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mm:ssZZ" inTimeZone:nil]; 
//    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mmZZ" inTimeZone:nil]; 
//    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mmZ" inTimeZone:nil]; 
    //	[eventMapping.dateFormatStrings addObject:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
}

- (void)addSerializationMappingsToObjectManager:(RKObjectManager*)objectManager {
    // Instrument Mapping
    RKManagedObjectMapping* instrument = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [instrument mapKeyPathsToAttributes: 
     @"instrumentId", @"instrument_id",
     @"responseSet", @"response_set",
     @"instrumentTemplateId", @"instrument_template_id",
     @"name", @"name", nil];
    [objectManager.mappingProvider setSerializationMapping:instrument forClass:[Instrument class]];
    
    // Event Mapping
    RKManagedObjectMapping* event = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [event mapKeyPathsToAttributes:
     @"eventId", @"event_id",
     @"name", @"name", nil];
    [event mapRelationship:@"instruments" withMapping:instrument];
    [objectManager.mappingProvider setSerializationMapping:event forClass:[Event class]];

        RKManagedObjectMapping* contact = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [contact mapKeyPathsToAttributes:
     @"contactId", @"contact_id", 
     @"typeId", @"type",
     @"startDate", @"start_date",
     @"endDate", @"end_date",
     @"personId", @"person_id", nil];
    [contact mapRelationship:@"events" withMapping:event];
    [objectManager.mappingProvider setSerializationMapping:contact forClass:[Contact class]];
    
    RKObjectMapping* fieldWorkMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class] ];
    [fieldWorkMapping mapKeyPathsToAttributes:@"fieldWordId", @"identifier", nil];
    [fieldWorkMapping mapRelationship:@"contacts" withMapping:contact];
    
    [objectManager.mappingProvider setSerializationMapping:fieldWorkMapping forClass:[FieldWork class]];

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
