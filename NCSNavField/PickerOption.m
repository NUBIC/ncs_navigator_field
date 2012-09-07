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
    return [[[NSArray alloc] initWithObjects:
             [self po:@"In-person" value:1],
//             [self po:@"Mail" value:2],
             [self po:@"Telephone" value:3],
//             [self po:@"Email" value:4],
//             [self po:@"Text Message" value:5],
//             [self po:@"Website" value:6],
             [self po:@"Other" value:-5],
             [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) whoContacted {
    return [[[NSArray alloc] initWithObjects:
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
            [self po:@"Missing in Error" value:-4], nil ] autorelease];
}

+ (NSArray*) language {
    return [[[NSArray alloc] initWithObjects:
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
            [self po:@"Missing in Error" value:-4], nil ] autorelease];
}

+ (NSArray*) interpreter {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Bilingual interviewer" value:1],
            [self po:@"In-person professional interpreter" value:2],
            [self po:@"In person family member interpreter" value:3],
            [self po:@"Language-line interpreter" value:4],
            [self po:@"Video interpreter" value:5],
            [self po:@"Sign Language Interpreter" value:6],
            [self po:@"Other" value:-5],
            [self po:@"Legitimate Skip" value:-3],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) location {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Person/participant home" value:1],
            [self po:@"NCS Site office" value:2],
            [self po:@"Provider office" value:3],
            [self po:@"Hospital" value:4],
            [self po:@"Community event" value:5],
            [self po:@"School" value:6],
            [self po:@"Other" value:-5],
            [self po:@"Missing in Error" value:-4] , nil] autorelease];
}

+ (NSArray*) private {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) disposition {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"I need codes" value:-1], nil] autorelease];
}

+ (NSArray*) eventTypes {
    return [[[NSArray alloc] initWithObjects:
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
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) incentives {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Monetary" value:1],
            [self po:@"Non-Monetary" value:2],
            [self po:@"Both Monetary and Non-Monetary" value:3],
            [self po:@"None" value:4],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) dispositionCategory {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Household Enumeration Events" value:1],
            [self po:@"Pregnancy Screening Events" value:2],
            [self po:@"General Study Visits (including CASI SAQs)" value:3],
            [self po:@"Mailed Back Self Administered Questionnaires" value:4],
            [self po:@"Telephone Interview Events" value:5], 
            [self po:@"Internet Survey Events" value:6],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) breakOff {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) instrumentTypes {
    return [[[NSArray alloc] initWithObjects:
        [self po:@"Household Enumeration Interview" value:1],
        [self po:@"Continuous Tracking Instrument" value:2],
        [self po:@"Pregnancy Screener Interview (EH)" value:3],
        [self po:@"Pregnancy Screener Interview (PB)" value:4],
        [self po:@"Pregnancy Screener Interview (HI,LI)" value:5],
        [self po:@"Pregnancy Probability Group Follow-Up Interview" value:6],
        [self po:@"Pregnancy Probability Group Follow-Up SAQ" value:7],
        [self po:@"Pre-Pregnancy Interview" value:8],
        [self po:@"Pregnancy Visit 1 Interview" value:9],
        [self po:@"Pregnancy Visit 1 SAQ" value:10],
        [self po:@"Pregnancy Visit 2 Interview " value:11],
        [self po:@"Pregnancy Visit 2  SAQ" value:12],
        [self po:@"Birth Interview" value:13],
        [self po:@"Low-Intensity Interview (Non & Pregnant)" value:14],
        [self po:@"Provider Based Recruitment Questionnaire" value:15],
        [self po:@"3-Month Mother Phone Interview" value:16],
        [self po:@"6-Month Mother Interview" value:17],
        [self po:@"6-Month Infant Feeding SAQ" value:18],
        [self po:@"9-Month Mother Phone Interview" value:19],
        [self po:@"12-Month Mother Interview" value:20],
        [self po:@"12-Month Mother SAQ" value:21],
        [self po:@"Pre-Pregnancy SAQ" value:22],
        [self po:@"18-Month Mother Interview" value:23],
        [self po:@"18-Month Mother SAQ" value:24],
        [self po:@"24-Month Mother Interview" value:25],
        [self po:@"24-Month Mother SAQ" value:26],
        [self po:@"Validation Instrument (All Visits through 12 Months)" value:27],
        [self po:@"Low Intensity Invitation to High-Intensity Conversion Interview" value:28],
        [self po:@"Biospecimen Cord Blood Instrument" value:29],
        [self po:@"Biospecimen Adult Blood Instrument" value:30],
        [self po:@"Biospecimen Adult Urine Instrument" value:31],
        [self po:@"Father Interview" value:32],
        [self po:@"Birth Interview (LI) (LOI13-SL-03-A)" value:33],
        [self po:@"Participant Internet Usage and Contact Preference Survey (LO12-INF-17)" value:34],
        [self po:@"Environmental Tap Water Pharmaceuticals (TWF) Technician Collect Instrument" value:35],
        [self po:@"Environmental Tap Water Pesticides (TWQ) Technician Collect Instrument" value:36],
        [self po:@"Environmental Vacuum Bag Dust (VBD) Technician Collect Instrument" value:37],
        [self po:@"Household Inventory Interview (HILI)" value:38],
        [self po:@"Other" value:-5],
        [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) instrumentStatuses {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Not started" value:1],
            [self po:@"Refused" value:-1],
            [self po:@"Partial" value:3],
            [self po:@"Complete" value:4],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) instrumentModes {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"In-person, Computer Assisted (CAPI/CASI)" value:1],
            [self po:@"Telephone, Computer Assisted (CATI)" value:2],
            [self po:@"In-Person, Paper and Pencil" value:3],
            [self po:@"Telephone, Paper and Pencil" value:4],
            [self po:@"Web-based" value:5],
            [self po:@"Other" value:-5],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) instrumentMethods {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Self-Administered" value:1],
            [self po:@"Interviewer-Administered" value:2],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}


+ (NSArray*) instrumentSupervisorReviews {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) instrumentDataProblems {
    return [[[NSArray alloc] initWithObjects:
            [self po:@"Yes" value:1],
            [self po:@"No" value:2],
            [self po:@"Missing in Error" value:-4], nil] autorelease];
}

+ (NSArray*) instrumentBreakoffs {
    return [[[NSArray alloc] initWithObjects:
        [self po:@"Yes" value:1],
        [self po:@"No" value:2],
        [self po:@"Missing in Error" value:-4], nil] autorelease];
}

- (void)dealloc {
    [_text release];
    [super dealloc];
}
@end
