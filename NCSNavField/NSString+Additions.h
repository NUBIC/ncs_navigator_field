//
//  NSString+Additions.h
//  NCSNavField
//
//  Created by John Dzak on 5/3/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (NSDate*)jsonTimeToDate;
-(NSDate*)fromYYYYMMDD;
- (BOOL)isBlank;
- (BOOL)isEmpty;
@end
