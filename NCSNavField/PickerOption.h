//
//  PickerOption.h
//  NCSNavField
//
//  Created by John Dzak on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerOption : NSObject {
    NSString* _text;
    NSInteger _value;
}

@property(nonatomic,strong) NSString* text;

- (id) initWithText:(NSString*)t value:(NSInteger)v;
-(NSDictionary*)toDict;
-(NSString*)toJSON;
- (NSInteger) value;
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
