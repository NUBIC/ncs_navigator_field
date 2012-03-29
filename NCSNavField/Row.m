//
//  Row.m
//  NCSNavField
//
//  Created by John Dzak on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Row.h"

@implementation Row

@synthesize entity=_entity;
@synthesize text=_text;
@synthesize detailText=_detailText;
@synthesize rowClass=_rowClass;
@synthesize editable=_editable;

- (id) initWithText:(NSString*)text {
    if (self = [super init]) {
        self.text = text;
    }
    return self;
}

- (id) initWithText:(NSString*)text detailText:(NSString*)dt {
    if (self = [super init]) {
        self.text = text;
        self.detailText = dt;
    }
    return self;
}

- (void) dealloc {
    [_entity release];
    [_text release];
    [_detailText release];
    [_rowClass release];
    [super dealloc];
}
@end
