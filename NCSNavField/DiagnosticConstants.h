//
//  DiagnosticConstants.h
//  NCSNavField
//
//  Created by Sam Hicks on 12/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

//This is included in places where we need to print out details to the user/help desk.

#ifndef NCSNavField_DiagnosticConstants_h
#define NCSNavField_DiagnosticConstants_h



#pragma mark - CAS Authentication error.

#define LOG_AUTH_SUCCESSED @"The authentication with CAS succeeded."
#define LOG_AUTH_FAILED @"The authentication with CAS failed."

#pragma mark - Logging fieldwork upload errors/diagnostics.

#define LOG_NEED_FIELDWORK_SUBMISSION_YES @"There is local fieldwork data to submit. We shall commence."
#define LOG_NEED_FIELDWORK_SUBMISSION_NO @"There is no local fieldwork data to submit. We move on."
#define LOG_FIELDWORK_UPLOAD_YES @"Fieldwork upload succeeded."
#define LOG_FIELDWORK_UPLOAD_NO @"Fieldwork upload failed. Possibly because the server is down. We needed to bail. See details below."

#pragma mark - Logging retrieving data during fieldwork step.

#define LOG_RETRIEVE_DATA_YES @"We successfully retrieved contacts and other information from the server."
#define LOG_RETRIEVE_DATA_NO @"We were not able to grab contacts and other important information from the server."

#pragma mark - Logging merge errors.

#define LOG_NEED_MERGE_ATTEMPT_YES @"We need to check the merge status on the server.. Let's go ahead and do that."
#define LOG_NEED_MERGE_ATTEMPT_NO @"We don't need to check the merge status on the server."
#define LOG_MERGING_YES @"We received information from the server saying that merging is done from our perspective. We'll move on."
#define LOG_MERGING_NO @"Merging failed. Check the reason below."
#define LOG_MERGING_THREE_FAILURES @"We have tried three times to merge data and it failed. See above and below for more information."
#define LOG_MERGE_TIMEOUT @"We timed out when we were trying to reach the server to retrieve the merge status."
#define LOG_UNSPECIFIED_DURING_MERGE @"We were trying to merge the data. If you didn't have any fieldwork to merge, the server could be down."
#define LOG_MERGE_QUIT @"We have tried merging three times. See above. Quitting..."

#pragma mark - Logging provider errors/diagnostics

#define LOG_RETRIEVE_PROVIDERS @"We need to go grab the providers from the server. Let's start."
#define LOG_RETRIEVE_PROVIDERS_NO @"We tried to get the providers and failed. See above/below for more details."
#define LOG_RETRIEVE_PROVIDERS_YES @"We successfully retrieved the providers from the server."

#pragma mark - Logging mdes code retrieval errors/diagnostics

#define LOG_MDES_RETRIEVE @"We need to go grab the providers from the server. Let's start."
#define LOG_MDES_RETRIEVE_NO @"We tried to get the MDES from the server. See below and/or above for more details."
#define LOG_MDES_RETRIEVE_YES @"We successfully retrieved the mdes from the server."

#endif
