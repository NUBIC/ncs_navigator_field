//
//  Contact.m
//  NCSMobile
//
//  Created by John Dzak on 9/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"
#import "Event.h"
#import "Person.h"

@implementation Contact

@dynamic typeId, startDate, endDate, person, initiated, location, events, whoContactedId, whoContactedOther, comments, languageId, languageOther, interpreterId, interpreterOther, privateId, privateDetail, distanceId, dispositionId;


- (BOOL) closed {
    return [self.dispositionId integerValue] != 0;
}

@end
