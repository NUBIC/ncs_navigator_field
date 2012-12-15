//
//  NUQuestion.h
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUQuestion : NSObject

@property(nonatomic,retain) NSString* text;

@property(nonatomic,retain) NSString* referenceIdentifier;

@property(nonatomic,retain) NSArray* answers;

- (id)initWithDictionary:dict;

@end
