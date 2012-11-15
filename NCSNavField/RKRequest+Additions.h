//
//  RKRequest+Additions.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "RKRequest.h"
#import "CasProxyTicket.h"
#import "ApplicationSettings.h"

@interface RKRequest (Additions)
-(void)addAdditionalHeaders:(CasProxyTicket*)t;
@end
