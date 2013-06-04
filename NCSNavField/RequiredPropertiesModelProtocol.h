//
//  RequiredPropertiesModelObject.h
//  NCSNavField
//
//  Created by Jacob Van Order on 6/4/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequiredPropertiesModelProtocol <NSObject>

-(BOOL) completed;

@optional

-(NSArray *) requiredProperties;
-(NSArray *) missingRequiredProperties;

@end
