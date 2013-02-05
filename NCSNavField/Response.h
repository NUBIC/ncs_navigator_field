//
//  Response.h
//  NCSNavField
//
//  Created by John Dzak on 2/1/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <NUSurveyor/NUResponse.h>

@interface Response : NUResponse

@property (nonatomic, retain) NSString * value;

- (NSDictionary*) toDict;

@end
