//
//  CasTicketException.h
//  NCSNavField
//
//  Created by John Dzak on 4/22/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CasTicketException : NSException

@property (strong,nonatomic) NSString* explanation;

- (id)initWithReason:(NSString*)reason explanation:(NSString*)explanation;

@end
