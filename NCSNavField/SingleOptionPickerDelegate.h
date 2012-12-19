//
//  SingleOptionPickerDelegate.h
//  NCSNavField
//
//  Created by Sam Hicks on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SingleOptionPicker;

@protocol SingleOptionPickerDelegate <NSObject>
-(void)selectionWasMade:(NSString*)str onPicker:(SingleOptionPicker*)p withValue:(NSUInteger)val;
@end
