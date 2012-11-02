//
//  Person.h
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSManagedObject

@property(nonatomic,strong) NSString* personId;
@property(nonatomic,strong) NSString* name;
@property(nonatomic,strong) NSString* email;
@property(nonatomic,strong) NSString* cellPhone;
@property(nonatomic,strong) NSString* homePhone;
@property(nonatomic,strong) NSString* street;
@property(nonatomic,strong) NSString* city;
@property(nonatomic,strong) NSString* zipCode; 
@property(nonatomic,strong) NSString* state;


@property(nonatomic,strong) NSString* participant;

#pragma mark - Methods

+ (Person*)person;

@end
