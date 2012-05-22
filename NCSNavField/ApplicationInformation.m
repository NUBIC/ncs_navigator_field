//
//  ApplicationInformation.m
//  NCSNavField
//
//  Created by John Dzak on 5/21/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "ApplicationInformation.h"

@implementation ApplicationInformation

+ (BOOL) isTestEnvironment {
    NSString* bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    return [bundleName rangeOfString:@"Test" options:NSCaseInsensitiveSearch].location != NSNotFound;
    
}

@end
