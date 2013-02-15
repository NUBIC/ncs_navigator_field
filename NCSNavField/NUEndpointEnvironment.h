//
//  NUEndpointEnvironment.h
//  NCSNavField
//
//  Created by Jacob Van Order on 2/19/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUEndpointEnvironment : NSObject <NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *coreURL;
@property (nonatomic, strong) NSURL *casServerURL;
@property (nonatomic, strong) NSURL *pgtReceiveURL;
@property (nonatomic, strong) NSURL *pgtRetrieveURL;

-(instancetype)initWithEnviromentDictionary:(NSDictionary *)environmentDictionary;

@end
