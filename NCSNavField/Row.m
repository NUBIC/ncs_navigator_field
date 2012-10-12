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

- (id) initWithText:(NSString*)t entity:(id)e rowClass:(NSString*)rc{
    if (self = [super init]) {
        self.text = t;
        self.entity = e;
        self.rowClass = rc;
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

@end
