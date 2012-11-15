//
//  HumanReadablePublicIdGenerator.h
//  NCSNavField
//
//  Created by John Dzak on 11/12/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Random : NSObject

+ (NSUInteger)randWithLimit:(NSUInteger)limit;

@end

@interface HumanReadablePublicIdGenerator : NSObject

+ (NSString*)generate;

@end
