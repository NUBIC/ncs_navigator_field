//
//  NUPickerVC+Additions.m
//  NCSNavField
//
//  Created by Sam Hicks on 12/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUPickerVC+Additions.h"

@implementation NUPickerVC (Additions)
//We need to establish a minimum size such that the title and the two buttons can be shown comfortably
#define MINIMUM_WIDTH_NU_PICKER 200

-(CGFloat)calculateNecessaryWidth:(NSArray*)arrOfStrings withFont:(UIFont *)f {
    CGFloat fMax = 0;
    CGFloat sTemp = 0;
    for(NSString *str in arrOfStrings) {
        sTemp = [f calculateWidth:str].width;
        fMax = (sTemp>fMax) ? sTemp : fMax;
    }
    return MAX(fMax,MINIMUM_WIDTH_NU_PICKER);
}
@end
