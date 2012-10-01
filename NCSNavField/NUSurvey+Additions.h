//
//  NUSurvey+Additions.h
//  NCSNavField
//
//  Created by John Dzak on 9/19/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "NUSurvey.h"

@interface NUSurvey (Additions)

- (NSString*)title;

- (NSString*)uuid;

- (NSDictionary*)deserialized;

@end
