//
//  UIFont+Additions.h
//  NCSNavField
//
//  Created by Sam Hicks on 12/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Additions)
//Take a given string, we will return the single lined length/height needed to hold the string.
//This can be used to calculate the needed width of a UISingleOptionPicker.
-(CGSize)calculateWidth:(NSString*)str;
@end
