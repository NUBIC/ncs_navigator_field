//
//  Person.h
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Dwelling;

@interface Person : NSManagedObject

@property(nonatomic,retain) NSString* personId;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* email;
@property(nonatomic,retain) NSString* cellPhone;
@property(nonatomic,retain) NSString* homePhone;
@property(nonatomic,retain) NSString* street;
@property(nonatomic,retain) NSString* city;
@property(nonatomic,retain) NSString* zipCode; 
@property(nonatomic,retain) NSString* state;


@property(nonatomic,retain) NSString* participant;

@end
