//
//  NSMutableString+Additions.h
//  NCSNavField
//
//  Created by Sam Hicks on 12/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiagnosticConstants.h"


@interface NSMutableString (Additions)
//Probably unnecessary but it allows us to localize the formatting of the messages.
//Right now its, message, new line, message, new line, etc. If we want to change it,
//change this method by using the "refactor" command.
-(void)appendStringAfterNewLine:(NSString*)strToAppend;
@end
