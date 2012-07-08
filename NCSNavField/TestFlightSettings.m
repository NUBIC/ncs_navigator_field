//
//  TestFlightSettings.m
//  NCSNavField
//
//  Created by John Dzak on 3/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "TestFlightSettings.h"

@implementation TestFlightSettings


@synthesize teamToken=_teamToken;

static TestFlightSettings* instance;

- (id)init {
    self = [super init];
    if (self) {
        _teamToken = [[[self retrieveTeamToken] retain] autorelease];
    }
    
    return self;
}

+ (TestFlightSettings*) instance {
    if (!instance) {
        instance = [[TestFlightSettings alloc] init];
    }
    return instance;
}

- (NSString*) retrieveTeamToken {
    NSString* token = NULL;
    NSData *data = [NSData dataWithContentsOfFile:[self teamTokenFilePath]];  
    if (data) {  
        token = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    }
    return token;
    
}

- (NSString*) teamTokenFilePath {
    return [[NSBundle mainBundle] pathForResource:@"TestFlight-TeamToken" ofType:@"txt"];
}
 
@end
