//
//  NSDate+Additions.h
//  NCSNavField
//
//  Created by John Dzak on 4/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)
- (NSString*)jsonSchemaDate;
- (NSString*)jsonSchemaTime;
- (NSString*)toRFC3339;
-(NSString*)toYYYYMMDD;
-(NSString*)lastModifiedFormat;
@end
