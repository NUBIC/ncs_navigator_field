//
//  NUAnswer.h
//  NCSNavField
//
//  Created by John Dzak on 12/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUAnswer : NSObject

@property(nonatomic,retain) NSString* referenceIdentifier;

- (id)initWithDictionary:(NSDictionary*)dict;

@end
