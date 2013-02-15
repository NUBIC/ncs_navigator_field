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
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.coreURL = [aDecoder decodeObjectForKey:@"coreURL"];
        self.casServerURL = [aDecoder decodeObjectForKey:@"casServerURL"];
        self.pgtReceiveURL = [aDecoder decodeObjectForKey:@"pgtReceiveURL"];
        self.pgtRetrieveURL = [aDecoder decodeObjectForKey:@"pgtRetrieveURL"];
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
        self.name = environmentDictionary[@"name"];
        self.coreURL = [NSURL URLWithString:environmentDictionary[@"cases_url"]];
        self.casServerURL = [NSURL URLWithString:environmentDictionary[@"cas_base_url"]];
        self.pgtReceiveURL = [NSURL URLWithString:environmentDictionary[@"cas_proxy_receive_url"]];
        self.pgtRetrieveURL = [NSURL URLWithString:environmentDictionary[@"cas_proxy_retrieve_url"]];
    }
    return self;
}

@end
