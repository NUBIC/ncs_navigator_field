//
//  NSMutableString+Additions.m
//  NCSNavField
//
//  Created by Sam Hicks on 12/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NSMutableString+Additions.h"

@implementation NSMutableString (Additions)
-(void)appendStringAfterNewLine:(NSString*)strToAppend {
    [self appendString:@"\n"];
    [self appendString:strToAppend];
}
@end
