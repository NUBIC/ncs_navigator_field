//
//  Instrument.h
//  NCSMobile
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InstrumentTemplate;
@class Event;

@interface Instrument : NSManagedObject 

@property(nonatomic,retain) NSString* instrumentId;

@property(nonatomic,retain) NSString* name;

@property(nonatomic,retain) NSString* responseSet;

@property(nonatomic,retain) NSString* instrumentTemplateId;

@property(nonatomic,retain) InstrumentTemplate* instrumentTemplate;

@property(nonatomic,retain) NSString* externalResponseSetId;

@property(nonatomic,retain) Event* event;

@end
