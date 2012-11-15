//
//  CasServiceTicket+Additions.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/15/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUCas.h"

@class CasProxyTicket;

@interface CasServiceTicket (Additions)
- (CasProxyTicket*) obtainProxyTicket:(NSString*)error;
@end
