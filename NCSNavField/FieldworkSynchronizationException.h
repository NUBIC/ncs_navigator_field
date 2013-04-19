//
//  FieldworkSynchronizationException.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldworkSynchronizationException : NSException

@property (strong,nonatomic) NSString* explanation;

- (id)initWithReason:(NSString*)reason explanation:(NSString*)explanation;

@end
