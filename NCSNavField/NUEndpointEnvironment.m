//
//  NUEndpointEnvironment.m
//  NCSNavField
//
//  Created by Jacob Van Order on 2/19/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import "NUEndpointEnvironment.h"

@implementation NUEndpointEnvironment

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _coreURL = [aDecoder decodeObjectForKey:@"coreURL"];
        _casServerURL = [aDecoder decodeObjectForKey:@"casServerURL"];
        _pgtReceiveURL = [aDecoder decodeObjectForKey:@"pgtReceiveURL"];
        _pgtRetrieveURL = [aDecoder decodeObjectForKey:@"pgtRetrieveURL"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.coreURL forKey:@"coreURL"];
    [aCoder encodeObject:self.casServerURL forKey:@"casServerURL"];
    [aCoder encodeObject:self.pgtReceiveURL forKey:@"pgtReceiveURL"];
    [aCoder encodeObject:self.pgtRetrieveURL forKey:@"pgtRetrieveURL"];
}

-(instancetype)initWithEnviromentDictionary:(NSDictionary *)environmentDictionary {
    
    self = [super init];
    if (self) {
        _name = environmentDictionary[@"name"];
        _coreURL = [NSURL URLWithString:environmentDictionary[@"cases_url"]];
        _casServerURL = [NSURL URLWithString:environmentDictionary[@"cas_base_url"]];
        _pgtReceiveURL = [NSURL URLWithString:environmentDictionary[@"cas_proxy_receive_url"]];
        _pgtRetrieveURL = [NSURL URLWithString:environmentDictionary[@"cas_proxy_retrieve_url"]];
    }
    return self;
}

@end
