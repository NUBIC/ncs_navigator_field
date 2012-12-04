//
//  UIFont+Additions.m
//  NCSNavField
//
//  Created by Sam Hicks on 12/4/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "UIFont+Additions.h"

#define VERY_LARGE_NUMBER 10000

@implementation UIFont (Additions)
-(CGSize)calculateWidth:(NSString*)str {
    CGSize proposedSize = [str sizeWithFont:self constrainedToSize:CGSizeMake(VERY_LARGE_NUMBER, VERY_LARGE_NUMBER)];
    return proposedSize;
}
@end
