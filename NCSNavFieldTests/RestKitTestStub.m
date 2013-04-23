//
//  RestKitStub.m
//  NCSNavField
//
//  Created by John Dzak on 4/19/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "RestKitTestStub.h"
#import "JSONParserNSJSONSerialization.h"

@implementation RestKitTestStub

static NSString* baseURL = @"http://field.test.local";

+ (NSString*)baseURL {
    return baseURL;
}

+ (void)inject {
    [RKObjectManager sharedManager].client = [[RKClient alloc] initWithBaseURLString:baseURL];
    [[RKParserRegistry sharedRegistry] setParserClass:[JSONParserNSJSONSerialization class] forMIMEType:RKMIMETypeJSON];
}

@end
