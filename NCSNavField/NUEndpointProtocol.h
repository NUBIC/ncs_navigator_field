//
//  NUEndpointProtocol.h
//  NCSNavField
//
//  Created by Jacob Van Order on 2/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NUEndpoint;

@protocol NUEndpointProtocol <NSObject>

-(void)getEndpointArrayWithCallback:(void (^)(NSArray *endpointArray, NSError *error))endpointBlock;
-(void)stopNetworkRequest;

@optional


@end
