//
//  FormBuilderCursor.m
//  NCSNavField
//
//  Created by John Dzak on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FormBuilderCursor.h"

@implementation FormBuilderCursor

@synthesize x=_x;
@synthesize y=_y;

- (id) init {
    if (self = [super init]) {
        self.x = 10;
        self.y = 10;
    }
    return self;
}

- (void) addNewLine {
    self.y += 40; // 10 for padding
}

@end
