//
//  NCSLoggingDelegate.h
//  NCSNavField
//
//  Created by Sam Hicks on 12/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DispositionCode.h"
#import "NSMutableString+Additions.h"

@protocol NCSLoggingDelegate
//Takes a nil terminated list of strings and appends them to the log with line breaks in between.
-(void)setContentByAppendingStrings:(NSString *)firstString, ... NS_REQUIRES_NIL_TERMINATION;
-(void)addLine:(NSString*)str; //add a line to the output that will go to the view.
-(void)showView; //handle displaying the view.
-(void)flush; //replace the current error log with a new one.
@end
