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

@property(nonatomic,retain) NSString* event;
@property(nonatomic,retain) NSString* disposition;
@property(nonatomic,retain) NSString* interimCode;

+ (NSArray*) all;
+ (NSArray*) pickerOptions;
- (PickerOption*) toPickerOption;
+ (NSArray*) pickerOptionsForContactTypeId:(NSNumber*)typeId;

@end
