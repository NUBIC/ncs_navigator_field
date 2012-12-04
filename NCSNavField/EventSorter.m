//
//  EventSorter.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/30/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "EventSorter.h"
#import "Event.h"

@implementation EventSorter

+ (NSComparisonResult)compareEvent:(Event*)a toEvent:(Event*)b {
    NSArray* eventOrder = [self eventOrderByEventTypeCode];
    NSNumber* indexA = [NSNumber numberWithInteger:[eventOrder indexOfObject:a.eventTypeCode]];
    NSNumber* indexB = [NSNumber numberWithInteger:[eventOrder indexOfObject:b.eventTypeCode]];
    return [indexA compare:indexB];
}

+ (NSArray*) eventOrderByEventTypeCode {
    return [NSArray arrayWithObjects:
        @1,  //Household Enumeration
        @2,  //Two Tier Enumeration
        @22, //Provider-Based Recruitment
        @3,  //Ongoing Tracking of Dwelling Units
        @34, //PBS Participant Eligibility Screening
        @35, //PBS Frame SAQ
        @4,  //Pregnancy Screening - Provider Group
        @5,  //Pregnancy Screening – High Intensity  Group
        @6,  //Pregnancy Screening – Low Intensity Group
        @9,  //Pregnancy Screening - Household Enumeration Group
        @29, //Pregnancy Screener
        @10, //Informed Consent
        @33, //Low Intensity Data Collection
        @32, //Low to High Conversion
        @7,  //Pregnancy Probability
        @8,  //PPG Follow-Up by Mailed SAQ
        @11, //Pre-Pregnancy Visit
        @12, //Pre-Pregnancy Visit SAQ
        @13, //Pregnancy Visit  1
        @14, //Pregnancy Visit #1 SAQ
        @15, //Pregnancy Visit  2
        @16, //Pregnancy Visit #2 SAQ
        @17, //Pregnancy Visit - Low Intensity Group
        @18, //Birth
        @19, //Father
        @20, //Father Visit SAQ
        @21, //Validation
        @23, //3 Month
        @24, //6 Month
        @25, //6-Month Infant Feeding SAQ
        @26, //9 Month
        @27, //12 Month
        @28, //12 Month Mother Interview SAQ
        @30, //18 Month
        @31, //24 Month
        @36, //30 Month
        @37, //36 Month
        @38, //42 Month
        @-5, //Other
        @-4, //Missing in Error
        nil];
}

@end
