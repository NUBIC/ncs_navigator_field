//
//  PickerOption.m
//  NCSNavField
//
//  Created by John Dzak on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerOption.h"

@implementation PickerOption

@synthesize text;

- (id) initWithText:(NSString*)t value:(NSInteger)v {
    if (self = [self init]) {
        self.text = t;
        _value = v;
    }
    return self;
}

- (NSInteger) value {
    return _value;
}

+ (PickerOption*) findWithValue:(NSInteger)value fromOptions:(NSArray*)options {
    for (PickerOption* o in options) {
        if (o.value == value) {
            return o;
        }
    }
    return NULL;
}

+ (PickerOption*) po:(NSString*)text value:(NSInteger)value {
    return [[[PickerOption alloc] initWithText:text value:value] autorelease];
}
  
// TODO: Move into external library like mdes gem
+ (NSArray*) contactTypes {
    return [[NSArray alloc] initWithObjects:
             [self po:@"In-person" value:1],
//             [self po:@"Mail" value:2],
             [self po:@"Telephone" value:3],
//             [self po:@"Email" value:4],
//             [self po:@"Text Message" value:5],
//             [self po:@"Website" value:6],
             [self po:@"Other" value:-5],
             [self po:@"Missing in Error" value:-4], nil];
}

+ (NSArray*) whoContacted {
    return [[NSArray alloc] initWithObjects:
            [self po:@"NCS Participant" value:1],
            [self po:@"Mother of NCS Child" value:2],
            [self po:@"Father of NCS Child" value:3],
            [self po:@"Alternate Caregiver of NCS Child" value:4],
            [self po:@"Household member" value:5],
            [self po:@"Neighbor" value:6],
            [self po:@"Non-resident family member" value:7],
            [self po:@"Provider" value:8],
            [self po:@"Friend" value:9],
            [self po:@"No contact made with anyone" value:10],
            [self po:@"Other" value:-5],
            [self po:@"Missing in Error" value:-4], nil ];
}

+ (NSArray*) language {
    return [[NSArray alloc] initWithObjects:
            [self po:@"English" value:1],
            [self po:@"Spanish" value:2],
            [self po:@"Arabic" value:3],
            [self po:@"Chinese" value:4],
            [self po:@"French" value:5],
            [self po:@"French Creole" value:6],
            [self po:@"German" value:7],
            [self po:@"Italian" value:8],
            [self po:@"Korean" value:9],
            [self po:@"Polish" value:10],
            [self po:@"Russian" value:11],
            [self po:@"Tagalog" value:12],
            [self po:@"Vietnamese" value:13],
            [self po:@"Urdu" value:14],
            [self po:@"Punjabi" value:15],
            [self po:@"Bengali" value:16],
            [self po:@"Farsi" value:17],
            [self po:@"Refused" value:-1],
            [self po:@"Other" value:-5],
            [self po:@"Unknown" value:-6],
            [self po:@"Missing in Error" value:-4], nil ];
}

+ (NSArray*) interpreter {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Bilingual interviewer" value:1],
            [self po:@"In-person professional interpreter" value:2],
            [self po:@"In person family member interpreter" value:3],
            [self po:@"Language-line interpreter" value:4],
            [self po:@"Video interpreter" value:5],
            [self po:@"Sign Language Interpreter" value:6],
            [self po:@"Other" value:-5],
            [self po:@"Legitimate Skip" value:-3],
            [self po:@"Missing in Error" value:-4], nil];
}

+ (NSArray*) location {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Person/participant home" value:1],
            [self po:@"NCS Site office" value:2],
            [self po:@"Provider office" value:3],
            [self po:@"Hospital" value:4],
            [self po:@"Community event" value:5],
            [self po:@"School" value:6],
            [self po:@"Other" value:-5],
            [self po:@"Missing in Error" value:-4] , nil];
}

+ (NSArray*) private {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
            [self po:@"Missing in Error" value:-4], nil];
}

+ (NSArray*) disposition {
    return [[NSArray alloc] initWithObjects:
            [self po:@"I need codes" value:-1], nil];
}

+ (NSArray*) eventTypes {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Household Enumeration" value:1],
            [self po:@"Two Tier Enumeration" value:2],
            [self po:@"Ongoing Tracking of Dwelling Units" value:3],
            [self po:@"Pregnancy Screening - Provider Group" value:4],
            [self po:@"Pregnancy Screening – High Intensity Group" value:5],
            [self po:@"Pregnancy Screening – Low Intensity Group " value:6],
            [self po:@"Pregnancy Probability" value:7],
            [self po:@"PPG Follow-Up by Mailed SAQ" value:8],
            [self po:@"Pregnancy Screening - Household Enumeration Group" value:9],
            [self po:@"Informed Consent" value:10],
            [self po:@"Pre-Pregnancy Visit" value:11],
            [self po:@"Pre-Pregnancy Visit SAQ" value:12],
            [self po:@"Pregnancy Visit 1" value:13],
            [self po:@"Pregnancy Visit #1 SAQ" value:14],
            [self po:@"Pregnancy Visit 2" value:15],
            [self po:@"Pregnancy Visit #2 SAQ" value:16],
            [self po:@"Pregnancy Visit - Low Intensity Group" value:17],
            [self po:@"Birth" value:18],
            [self po:@"Father" value:19],
            [self po:@"Father Visit SAQ" value:20],
            [self po:@"Validation" value:21],
            [self po:@"Provider-Based Recruitment" value:22],
            [self po:@"3 Month" value:23],
            [self po:@"6 Month" value:24],
            [self po:@"6-Month Infant Feeding SAQ" value:25],
            [self po:@"9 Month" value:26],
            [self po:@"12 Month" value:27],
            [self po:@"12 Month Mother Interview SAQ" value:28],
            [self po:@"Pregnancy Screener" value:29],
            [self po:@"18 Month" value:30],
            [self po:@"24 Month" value:31],
            [self po:@"Low to High Conversion" value:32],
            [self po:@"Low Intensity Data Collection" value:33],
            [self po:@"Other" value:-5],
            [self po:@"Missing in Error" value:-4], nil];
}

+ (NSArray*) incentives {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Monetary" value:1],
            [self po:@"Non-Monetary" value:2],
            [self po:@"Both Monetary and Non-Monetary" value:3],
            [self po:@"None" value:4],
            [self po:@"Missing in Error" value:-4], nil];
}

+ (NSArray*) dispositionCategory {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Household Enumeration Events" value:1],
            [self po:@"Pregnancy Screening Events" value:2],
            [self po:@"General Study Visits (including CASI SAQs)" value:3],
            [self po:@"Mailed Back Self Administered Questionnaires" value:4],
            [self po:@"Telephone Interview Events" value:5], 
            [self po:@"Internet Survey Events" value:6], nil];
}

+ (NSArray*) breakoff {
    return [[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
            [self po:@"Missing in Error" value:-4], nil];
}

@end
