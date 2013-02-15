//
//  NUEndpointService.m
//  NCSNavField
//
//  Created by Jacob Van Order on 2/14/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointService.h"
#import "NUEndpointLiveService.h"
#import "NUEndpointMockService.h"

@implementation NUEndpointService

+(id<NUEndpointProtocol>)service {
    static dispatch_once_t onceToken;
    static id <NUEndpointProtocol> service;
    dispatch_once(&onceToken, ^{ service = [NUEndpointLiveService new]; });
//    dispatch_once(&onceToken, ^{ service = [NUEndpointMockService new]; });
    return service;
}

@end
