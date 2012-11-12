//
//  DispositionCode.h
//  NCSNavField
//
//  Created by John Dzak on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PickerOption;

@interface DispositionCode : NSObject {
    NSString* _event;
    NSString* _disposition;
    NSString* _interimCode;
}

@property(nonatomic,strong) NSString* event;
@property(nonatomic,strong) NSString* disposition;
@property(nonatomic,strong) NSString* interimCode;

+ (NSArray*) all;
+ (NSArray*) pickerOptions;
- (PickerOption*) toPickerOption;
+ (NSArray*) pickerOptionsForContactTypeId:(NSNumber*)typeId;
-(NSString*)toJsonString;
-(NSDictionary*)toDict;
@end
