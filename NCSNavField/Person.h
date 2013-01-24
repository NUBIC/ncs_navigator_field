//
//  Person.h
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSInteger const PERSON_RELATIONSHIP_CODE_SELF;

@class Participant;

@interface Person : NSManagedObject

@property(nonatomic,strong) NSString* cellPhone;
@property(nonatomic,strong) NSString* city;
@property(nonatomic,strong) NSString* email;
@property(nonatomic,strong) NSString* firstName;
@property(nonatomic,strong) NSString* homePhone;
@property(nonatomic,strong) NSString* lastName;
@property(nonatomic,strong) NSString* middleName;
@property(nonatomic,strong) NSString* personId;
@property(nonatomic,strong) NSNumber* prefixCode;
@property(nonatomic,strong) NSNumber* relationshipCode;
@property(nonatomic,strong) NSString* state;
@property(nonatomic,strong) NSString* street;
@property(nonatomic,strong) NSNumber* suffixCode;
@property(nonatomic,strong) NSString* zipCode;
@property (nonatomic, strong) Participant *participant;

#pragma mark - Methods

+ (Person*)person;

- (NSString*)addressLineOne;

- (NSString*)addressLineTwo;

- (NSString*)formattedAddress;

- (NSString*)name;

- (BOOL) isPersonSameAsParticipant;

@end
