//
//  NUPickerVC+Additions.m
//  NCSNavField
//
//  Created by Sam Hicks on 12/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUPickerVC+Additions.h"

@implementation NUPickerVC (Additions)

-(CGFloat)calculateNecessaryWidth:(NSArray*)arrOfStrings withFont:(UIFont *)f {
    CGFloat fMax = 0;
    CGFloat sTemp = 0;
    for(NSString *str in arrOfStrings) {
        sTemp = [f calculateWidth:str].width;
        fMax = (sTemp>fMax) ? fMax : sTemp;
    }
    return fMax;
}
@end
