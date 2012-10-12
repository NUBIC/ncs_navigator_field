//
//  TestFlightSettings.h
//  NCSNavField
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface TestFlightSettings : NSObject {
    NSString* _teamToken;
}

@property(nonatomic,strong) NSString* teamToken;

+ (TestFlightSettings*) instance;

- (NSString*) retrieveTeamToken;
- (NSString*) teamTokenFilePath;

@end
