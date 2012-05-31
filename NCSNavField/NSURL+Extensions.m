//
//  NSURL+Extensions.m
//  NCSNavField
//
//  Created by John Dzak on 5/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NSURL+Extensions.h"

@implementation NSURL (Extensions)

- (NSURL*) urlByAppendingPathComponent: (NSString*) component {
    CFURLRef newURL = CFURLCreateCopyAppendingPathComponent( kCFAllocatorDefault, (CFURLRef)[self absoluteURL], (CFStringRef)component, [component hasSuffix:@"/"] );
    return [NSMakeCollectable(newURL) autorelease];
}

@end
