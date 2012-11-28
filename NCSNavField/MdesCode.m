//
//  MdesCode.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "MdesCode.h"


@implementation MdesCode

@dynamic displayText;
@dynamic listName;
@dynamic localCode;

/*
 Use NSManagedObject+ActiveRecord.h to retrieve the data.
 //Here's the method we will use.
 + (NSArray *)findAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
 */

+(NSArray*)retrieveAllObjectsForListName:(NSString*)listName
{
    NSLog(@"Retrieving List Name: %@",listName);
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listName == %@", listName];
        NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[self findAllSortedBy:@"localCode" ascending:NO withPredicate:predicate inContext:[MdesCode managedObjectContext]]];
        //We should do some error handing here based on anything returned from error.

        //YUCK!
        int nIdx = -1;
        for(int i=0;i<[results count];i++) {
            MdesCode *code = [results objectAtIndex:i];
            if([code.localCode isEqualToNumber:[NSNumber numberWithInt:-4]]) {
                nIdx = i;
                break;
            }
        }
        if(nIdx>=0)
            [results removeObjectAtIndex:nIdx];
        return results;
}

+(void)createMdesCode:(NSString*)t listName:(NSString*)li localCode:(NSNumber*)lc {
    NSManagedObjectContext *context = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    NSEntityDescription *MdesEntity = [NSEntityDescription
                                           entityForName:@"MdesCode"
                                           inManagedObjectContext:context];
    MdesCode *code = (MdesCode*)[[NSManagedObject alloc]
                                    initWithEntity:MdesEntity
                                    insertIntoManagedObjectContext:context];
    code.localCode = lc;
    code.displayText = t;
    code.listName = li;
}

-(NSString*)text {
    return self.displayText;
}

+ (NSArray*)all {
    NSManagedObjectContext *context = [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"MdesCode" inManagedObjectContext:context]];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    return results;
}
                               
+(NSManagedObjectContext*)managedObjectContext {
   return [RKObjectManager sharedManager].objectStore.managedObjectContextForCurrentThread;
}

#pragma mark - 
#pragma Create Yes/No Lists.

//They want to stop and come back later if "yes".
+ (NSArray*) breakOff {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"breakOff"];
    if([arr count]==0) {
        [MdesCode createMdesCode:@"Yes" listName:@"breakOff" localCode:[NSNumber numberWithInt:1]];
        [MdesCode createMdesCode:@"No" listName:@"breakOff" localCode:[NSNumber numberWithInt:2]];
    }
    else
        return arr;
    return [self breakOff];
}

+ (NSArray*) instrumentSupervisorReviews {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"instrumentSupervisorReviews"];
    if([arr count]==0) {
        [MdesCode createMdesCode:@"Yes" listName:@"instrumentSupervisorReviews" localCode:[NSNumber numberWithInt:1]];
        [MdesCode createMdesCode:@"No" listName:@"instrumentSupervisorReviews" localCode:[NSNumber numberWithInt:2]];
    }
    return [self instrumentSupervisorReviews];
}

+ (NSArray*) privateList {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"privateList"];
    if([arr count]==0) {
        [MdesCode createMdesCode:@"Yes" listName:@"privateList" localCode:[NSNumber numberWithInt:1]];
        [MdesCode createMdesCode:@"No" listName:@"privateList" localCode:[NSNumber numberWithInt:2]];
    }
    else
        return arr;
    return [self privateList];
}

+ (NSArray*) instrumentDataProblems {
    NSArray *arr = [MdesCode retrieveAllObjectsForListName:@"instrumentDataProblems"];
    if([arr count]==0) {
        [MdesCode createMdesCode:@"Yes" listName:@"instrumentDataProblems" localCode:[NSNumber numberWithInt:1]];
        [MdesCode createMdesCode:@"No" listName:@"instrumentDataProblems" localCode:[NSNumber numberWithInt:2]];
    }
    return [self instrumentDataProblems];
}



@end