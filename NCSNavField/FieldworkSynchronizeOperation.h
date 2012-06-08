//
//  FieldworkSynchronizer.h
//  NCSNavField
//
//  Created by John Dzak on 4/27/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldworkSynchronizeOperation : NSObject {
    CasServiceTicket* _ticket;
}

@property(nonatomic,retain) CasServiceTicket* ticket;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket;

- (BOOL) perform;

- (NSString*) submit;

- (BOOL)receive;

- (BOOL) poll:(NSString*)mergeStatusId;

@end
