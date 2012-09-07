//
//  InstrumentTemplate.h
//  NCSNavField
//
//  Created by John Dzak on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstrumentTemplate : NSManagedObject

@property(nonatomic,retain) NSString* instrumentTemplateId;
@property(nonatomic,retain) NSString* representation;
@property(nonatomic,retain) NSString* participantType;

@end
