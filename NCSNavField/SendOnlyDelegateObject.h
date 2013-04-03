//
//  SendOnlyDelegateObject.h
//  NCSNavField
//
//  Created by Jacob Van Order on 4/2/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SendOnlyDelegate;

@interface SendOnlyDelegateObject : NSObject <CasLoginVCDelegate>

@property (nonatomic, weak) id<SendOnlyDelegate>delegate;

@end

@protocol SendOnlyDelegate <NSObject>
- (void)sendOnlyDelegate:(SendOnlyDelegateObject *)retrieveDelegateObject didSuccessfullyObtainedServiceTicket:(CasServiceTicket *)serviceTicket;
- (void)sendOnlyDelegateDidCancel:(SendOnlyDelegateObject *)retrieveDelegateObject;
@end
