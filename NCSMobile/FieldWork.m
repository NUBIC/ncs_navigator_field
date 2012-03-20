//
//  FieldWork.m
//  NCSMobile
//
//  Created by John Dzak on 3/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldWork.h"

@implementation FieldWork

@synthesize identifier;

@dynamic location, retreivedDate, participants, contacts, instrumentTemplates;

// TODO: This is a workaround for a problem caused when calling 
- (BOOL)isNew {
    return false;
}
@end
