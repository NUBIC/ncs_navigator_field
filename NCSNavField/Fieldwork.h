//
//  FieldWork.h
//  NCSNavField
//
//  Created by John Dzak on 3/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

@class Contact, InstrumentTemplate, Participant;

@interface Fieldwork : NSManagedObject

@property(weak, readonly) NSString *fieldworkId;

@property(nonatomic,strong) NSString* uri;

@property(nonatomic,strong) NSDate* retrievedDate;

+ (Fieldwork*)submission;

@end
