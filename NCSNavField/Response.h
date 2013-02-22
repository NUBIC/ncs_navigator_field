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

@property(nonatomic,retain) NSString* answer;
@property(nonatomic,retain) NSString* question;
@property(nonatomic,retain) NSString* uuid;
@property(nonatomic,retain) NSString* value;

- (NSDictionary*) toDict;

@end
