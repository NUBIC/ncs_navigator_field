//
//  ResponseSetMustacheContext.h
//  NCSNavField
//
//  Created by John Dzak on 2/20/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResponseSet;

@interface ResponseSetMustacheContext : NSObject

@property(nonatomic,strong) ResponseSet* responseSet;

- (ResponseSetMustacheContext*)initWithResponseSet:(ResponseSet*)rs;

- (NSDictionary*)toDictionary;

@end
