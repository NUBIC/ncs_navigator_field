//
//  SendOnlyDelegateObject.m
//  NCSNavField
//
//  Created by Jacob Van Order on 4/2/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "SendOnlyDelegateObject.h"

@implementation SendOnlyDelegateObject

#pragma mark delegate methods

-(void)casLoginVC:(CasLoginVC *)casLoginVC didSuccessfullyObtainedServiceTicket:(CasServiceTicket *)serviceTicket {
    [self.delegate sendOnlyDelegate:self didSuccessfullyObtainedServiceTicket:serviceTicket];
}

-(void)casLoginVCDidCancel:(CasLoginVC *)casLoginVC {
    [self.delegate sendOnlyDelegateDidCancel:self];
}

@end
