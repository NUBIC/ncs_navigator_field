//
//  PickerOption.m
//  NCSNavField
//
//  Created by John Dzak on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerOption.h"
#import "MdesCode.h"

@implementation PickerOption

@synthesize text,value,listName;

- (id) initWithText:(NSString*)t value:(NSInteger)v {
    if (self = [self init]) {
        self.text = t;
        self.value = [NSNumber numberWithInt:v];
    }
    return self;
}

-(NSDictionary*)toDict {
    return [[NSDictionary alloc] initWithObjectsAndKeys:self.text,@"display_text",self.value,@"local_code",self.listName,@"list_name",nil];
}

-(NSString*)toJSON {
    NSDictionary *dict = [self toDict];
    NSString *str = [[[SBJSON alloc] init] stringWithObject:dict];
    return str;
}


+ (PickerOption*) findWithValue:(NSInteger)val fromOptions:(NSArray*)options {
    for (PickerOption* o in options) {
        if (o.value == [NSNumber numberWithInt:val]) {
            return o;
        }
    }
    return NULL;
}

+ (PickerOption*) po:(NSString*)text value:(NSInteger)val {
    return [[PickerOption alloc] initWithText:text value:val];
}
  
// TODO: Move into external library like mdes gem
+ (NSArray*) contactTypes {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"CONTACT_TYPE_CL1" orderedBy:@"local code" ascending:YES];
    return arr;
}

+ (NSArray*) whoContacted {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"CONTACTED_PERSON_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}

+ (NSArray*) language {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"LANGUAGE_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}

+ (NSArray*) interpreter {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"TRANSLATION_METHOD_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}

+ (NSArray*) location {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"CONTACT_LOCATION_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}

+ (NSArray*) private {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
             nil];
}

+ (NSArray*) disposition {
    return [[NSArray alloc] initWithObjects:
            [self po:@"I need codes" value:-1], nil];
}

+ (NSArray*) eventTypes {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"EVENT_TYPE_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}

+ (NSArray*) incentives {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"INCENTIVE_TYPE_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}

+ (NSArray*) dispositionCategory {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"INCENTIVE_TYPE_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}
//They want to stop and come back later if "yes".
+ (NSArray*) breakOff {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
            nil];
}

+ (NSArray*) instrumentTypes {
    //EVENT_DSPSTN_CAT_CL1
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"EVENT_DSPSTN_CAT_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}

+ (NSArray*) instrumentStatuses {
    //INSTRUMENT_STATUS_CL1
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"INSTRUMENT_STATUS_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}

+ (NSArray*) instrumentModes {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"INSTRUMENT_ADMIN_MODE_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}

+ (NSArray*) instrumentMethods {
    //INSTRUMENT_ADMIN_METHOD_CL1
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"INSTRUMENT_ADMIN_METHOD_CL1" orderedBy:@"localCode" ascending:YES];
    return arr;
}


+ (NSArray*) instrumentSupervisorReviews {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
             nil];
}

+ (NSArray*) instrumentDataProblems {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
             nil];
}

+ (NSArray*) instrumentBreakoffs {
    return [[NSArray alloc] initWithObjects:
        [self po:@"Yes" value:1],
        [self po:@"No" value:2],
         nil];
}

@end
