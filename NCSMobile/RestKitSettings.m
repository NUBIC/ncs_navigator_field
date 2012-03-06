//
//  RestKitSettings.m
//  NCSMobile
//
//  Created by John Dzak on 3/6/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "RestKitSettings.h"
#import "ApplicationConfiguration.h"
#import "Event.h"
#import "Person.h"
#import "Instrument.h"
#import "Address.h"
#import "Location.h"
#import "NUResponseSet.h"
#import "Contact.h"
#import "InstrumentTemplate.h"
#import "ApplicationConfiguration.h"

@implementation RestKitSettings

@synthesize baseServiceURL = _baseServiceURL;
@synthesize objectStoreFileName = _objectStoreFileName;

- (id)init {
    self = [super init];
    if (self) {
        _baseServiceURL = [ApplicationConfiguration instance].coreURL;
        _objectStoreFileName = @"main.sqlite";
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
    
    // Enable automatic network activity indicator management
    [RKClient sharedClient].requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    [self addMappingsToObjectManager: objectManager];    
}

- (void)addMappingsToObjectManager:(RKObjectManager *)objectManager  {
    // Instrument Template
    RKManagedObjectMapping* instrumentTemplate = [RKManagedObjectMapping mappingForClass:[InstrumentTemplate class]];
    [instrumentTemplate mapKeyPathsToAttributes:
     @"id", @"identifier",
     @"representation", @"representation", nil];
    [instrumentTemplate setPrimaryKeyAttribute:@"identifier"];
    [objectManager.mappingProvider setMapping:instrumentTemplate forKeyPath:@"instrument_templates"];
    
    // Instrument Mapping
    RKManagedObjectMapping* instrument = [RKManagedObjectMapping mappingForClass:[Instrument class]];
    [instrument mapKeyPathsToAttributes: 
     @"instrument_template_id", @"instrumentTemplateId", 
     @"name", @"name", nil];
    [instrument mapRelationship:@"instrumentTemplate" withMapping:instrumentTemplate];
    [instrument connectRelationship:@"instrumentTemplate" withObjectForPrimaryKeyAttribute:@"instrumentTemplateId"];
    
    // Event Mapping
    RKManagedObjectMapping* event = [RKManagedObjectMapping mappingForClass:[Event class]];
    [event mapKeyPathsToAttributes: 
     @"name", @"name", nil];
    [event mapRelationship:@"instruments" withMapping:instrument];
    
    // Address Mapping
    RKManagedObjectMapping *address = [RKManagedObjectMapping mappingForClass:[Address class]];
    [address mapKeyPathsToAttributes:
     @"street", @"street",
     @"city", @"city",
     @"state", @"state",
     @"zip_code", @"zipCode", nil];
    
    // Location Mapping
    RKManagedObjectMapping* location = [RKManagedObjectMapping mappingForClass:[Location class]];
    [location mapKeyPathsToAttributes:
     @"code", @"code",
     @"other", @"other",
     @"details", @"details", nil];
    [location mapRelationship:@"address" withMapping:address];
    
    // Person Mapping
    RKManagedObjectMapping* person = [RKManagedObjectMapping mappingForClass:[Person class]];
    [person mapKeyPathsToAttributes: 
     @"id", @"id",
     @"name", @"name",
     @"home_phone", @"homePhone",
     @"cell_phone", @"cellPhone",
     @"email", @"email", nil];
    
    // Contact Mapping
    RKManagedObjectMapping* contact = [RKManagedObjectMapping mappingForClass:[Contact class]];
    [contact mapKeyPathsToAttributes:
     @"type", @"typeId", 
     @"start_date", @"startDate",
     @"end_date", @"endDate", nil];
    [contact mapRelationship:@"person" withMapping:person];
    [contact mapRelationship:@"location" withMapping:location];
    [contact mapRelationship:@"events" withMapping:event];
    [objectManager.mappingProvider setMapping:contact forKeyPath:@"contacts"];
    
    // "2005-07-16T19:20+01:00",
    //http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369
    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy'-'MM'-'dd'T'HH':'mm'Z'" inTimeZone:nil];
    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mm:ssZZ" inTimeZone:nil]; 
    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mmZZ" inTimeZone:nil]; 
    [RKManagedObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'hh:mmZ" inTimeZone:nil]; 
    //	[eventMapping.dateFormatStrings addObject:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
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
