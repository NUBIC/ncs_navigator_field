//
//  NUTranslation.h
//  NCSNavField
//
//  Created by Jacob Van Order on 5/3/13.
//  Copyright (c) 2013 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InstrumentTemplate, NUQuestion;

@interface NUTranslation : NSManagedObject

@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) InstrumentTemplate *instrumentTemplate;
@property (nonatomic, retain) NSSet *questions;
@end

@interface NUTranslation (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(NUQuestion *)value;
- (void)removeQuestionsObject:(NUQuestion *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end
