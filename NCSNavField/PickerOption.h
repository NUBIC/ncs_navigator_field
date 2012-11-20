//
//  PickerOption.h
//  NCSNavField
//
//  Created by John Dzak on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"

@interface PickerOption : NSObject {
    NSString *text;
    NSNumber *value;
}

@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) NSNumber *value;
@property(nonatomic,strong) NSString *listName;

- (id) initWithText:(NSString*)t value:(NSInteger)v;
-(NSDictionary*)toDict:(NSString*)listName;
-(NSString*)toJSON:(NSString*)listName;
-(void)writeToFile;
+ (NSArray*) contactTypes;
+ (PickerOption*) findWithValue:(NSInteger)value fromOptions:(NSArray*)options; 
+ (NSArray*) contactTypes;
+ (NSArray*) whoContacted;
+ (NSArray*) language;
+ (NSArray*) interpreter;
+ (NSArray*) location;
+ (NSArray*) private;
+ (NSArray*) disposition;
+ (NSArray*) eventTypes;
+ (NSArray*) incentives;
+ (NSArray*) dispositionCategory;
+ (NSArray*) breakOff;
+ (NSArray*) instrumentTypes;
+ (NSArray*) instrumentStatuses;
+ (NSArray*) instrumentModes;
+ (NSArray*) instrumentMethods;
+ (NSArray*) instrumentSupervisorReviews;
+ (NSArray*) instrumentDataProblems;
+ (NSArray*) instrumentBreakoffs;

@end
