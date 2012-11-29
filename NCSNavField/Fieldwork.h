//
//  FieldWork.h
//  NCSNavField
//
//  Created by John Dzak on 3/14/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Contact, InstrumentTemplate, Participant;

@interface Fieldwork : NSManagedObject

@property(weak, readonly) NSString *fieldworkId;

@property(nonatomic,strong) NSString* uri;

@property(nonatomic,strong) NSDate* retrievedDate;

@property(nonatomic,strong) NSSet* participants;

@property(nonatomic,strong) NSSet* contacts;

@property(nonatomic,strong) NSSet* instrumentTemplates;

+ (Fieldwork*)fieldworkToBeSubmitted;

@end

@interface Fieldwork (CoreDataGeneratedAccessors)

- (void)addContactsObject:(Contact *)value;
- (void)removeContactsObject:(Contact *)value;
- (void)addContacts:(NSSet *)values;
- (void)removeContacts:(NSSet *)values;

- (void)addInstrumentTemplatesObject:(InstrumentTemplate *)value;
- (void)removeInstrumentTemplatesObject:(InstrumentTemplate *)value;
- (void)addInstrumentTemplates:(NSSet *)values;
- (void)removeInstrumentTemplates:(NSSet *)values;

- (void)addParticipantsObject:(Participant *)value;
- (void)removeParticipantsObject:(Participant *)value;
- (void)addParticipants:(NSSet *)values;
- (void)removeParticipants:(NSSet *)values;

@end
