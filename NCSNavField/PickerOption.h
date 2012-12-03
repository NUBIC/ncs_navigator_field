//
//  PickerOption.h
//  NCSNavField
//
//  Created by John Dzak on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJSON.h"
#import "MdesCode.h"

@interface PickerOption : NSObject {
    NSString *text;
    NSObject *value;
}

@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) NSObject *value;
@property(nonatomic,strong) NSString *listName;

- (id) initWithText:(NSString*)t value:(NSObject*)v;
+ (PickerOption*) findWithValue:(NSObject*)value fromOptions:(NSArray*)options;

@end
