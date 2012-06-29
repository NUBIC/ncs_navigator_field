//
//  Section.m
//  NCSNavField
//
//  Created by John Dzak on 9/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Section.h"

@implementation Section

@synthesize rows=_rows;
@synthesize name=_name;

- (Section*)initWithName:(NSString*)name andRows:(NSArray*) rows {
    if (self = [super init]) {
        self.name = name;
        self.rows = rows;
    }
    return self;
}

- (void)addRow:(Row*)row{
    NSMutableArray *rows = [NSMutableArray arrayWithArray:self.rows];
    [rows addObject:row];
    self.rows = rows;
}

- (void) dealloc {
    [_rows release];
    [_name release];
    [super dealloc];
}

@end
