//
//  Instrument.h
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstrumentTemplate;
@class Event;
@class NUResponseSet;

@interface Instrument : NSManagedObject 

@property(nonatomic,retain) NSString* instrumentId;

@property(nonatomic,retain) NSString* name;

@property(getter = responseSetJson,readonly) NSString* responseSetJson;

@property(getter = responseSet, readonly) NUResponseSet* responseSet;

@property(nonatomic,retain) NSString* instrumentTemplateId;

@property(nonatomic,retain) InstrumentTemplate* instrumentTemplate;

@property(nonatomic,retain) NSString* externalResponseSetId;

@property(nonatomic,retain) Event* event;

@end
