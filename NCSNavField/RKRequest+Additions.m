//
//  RKRequest+Additions.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "RKRequest+Additions.h"

@implementation RKRequest (Additions)
-(void)addAdditionalHeaders:(CasProxyTicket*)t {
    NSMutableDictionary *headers = [NSMutableDictionary new];
    [headers setValue:@"application/json" forKey: @"Content-Type"];
    [headers setValue:[NSString stringWithFormat:@"CasProxy %@", t.proxyTicket] forKey:@"Authorization"];
    [headers setValue:ApplicationSettings.instance.clientId forKey:@"X-Client-ID"];
    self.additionalHTTPHeaders = headers;
}
@end
