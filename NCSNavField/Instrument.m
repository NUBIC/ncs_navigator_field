//
//  Instrument.m
//  NCSNavField
//
//  Created by John Dzak on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Instrument.h"
#import "SBJSON.h"

@implementation Instrument

@dynamic instrumentId, name, instrumentTemplateId, instrumentTemplate, externalResponseSetId, event, instrumentTypeId, instrumentTypeOther,
    instrumentVersion, repeatKey, startDate, startTime, endDate, endTime,
    statusId, breakoffId, instrumentModeId, instrumentModeOther,
    instrumentMethodId, supervisorReviewId, dataProblemId, comment;

- (NUResponseSet*) responseSet {
    NSManagedObjectContext* moc = [NUResponseSet managedObjectContext];
    NSEntityDescription *desc = [NSEntityDescription entityForName:@"ResponseSet" inManagedObjectContext:moc];
    NSFetchRequest *req = [[[NSFetchRequest alloc] init] autorelease];
    
    [req setEntity:desc];
    
    NSPredicate *p = [NSPredicate predicateWithFormat:
                      @"uuid = %@", self.externalResponseSetId];
    
    [req setPredicate:p];
    
    NSError *error = nil;
    
    NSArray *array = [moc executeFetchRequest:req error:&error];
    
    NUResponseSet* rs = NULL;
    if (array != nil) {
        NSLog(@"fetched response set");
        rs = [[array objectEnumerator] nextObject];
    } else {
        NSLog(@"Error during fetch");                
    }
    
    return rs;
}

- (void)setResponseSet:(NUResponseSet *)responseSet {
    self.externalResponseSetId = [responseSet valueForKey:@"uuid"];
}

- (NSDictionary*) responseSetDict {
    return self.responseSet.toDict;
}

- (void) setResponseSetDict:(NSDictionary *)responseSetDict {
    NSManagedObjectModel* mom = [RKObjectManager sharedManager].objectStore.managedObjectModel;
    NSEntityDescription *entity =
    [[mom entitiesByName] objectForKey:@"ResponseSet"];
    NUResponseSet *rs = [[NUResponseSet alloc]
                         initWithEntity:entity insertIntoManagedObjectContext:[NUResponseSet managedObjectContext]];
    

    [rs fromJson:[[[SBJSON alloc] init] stringWithObject:responseSetDict]];
    self.externalResponseSetId = [rs valueForKey:@"uuid"];
}

@end
