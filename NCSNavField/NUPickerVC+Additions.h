//
//  NUPickerVC+Additions.h
//  NCSNavField
//
//  Created by Sam Hicks on 12/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUPickerVC.h"
#import "UIFont+Additions.h"

@interface NUPickerVC (Additions)
//Pass in an array of NSString objects and this method will calculate the minimum
//width necessary to view the values in full with the given font (this will not include padding.)
-(CGFloat)calculateNecessaryWidth:(NSArray*)arrOfStrings withFont:(UIFont*)f;
@end
