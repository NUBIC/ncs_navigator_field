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
    NSNumber *value;
}

@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) NSNumber *value;
@property(nonatomic,strong) NSString *listName;

- (id) initWithText:(NSString*)t value:(NSInteger)v;
-(NSDictionary*)toDict:(NSString*)listName;
-(NSString*)toJSON:(NSString*)listName;
+ (MdesCode*) findWithValue:(NSInteger)value fromOptions:(NSArray*)options;
-(NSNumber*)value;
@end
