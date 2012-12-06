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

#define LOG_NEED_FIELDWORK_SUBMISSION_YES @"There is local fieldwork data to submit. We shall commence."
#define LOG_NEED_FIELDWORK_SUBMISSION_NO @"There is no local fieldwork data to submit. We move on."
#define LOG_NEED_MERGE_ATTEMPT_YES @"We need to try a merge."
#define LOG_NEED_MERGE_ATTEMPT_NO @"No merge attempt is necessary."
#define LOG_AUTH_SUCCESSED @"The authentication with CAS succeeded."
#define LOG_AUTH_FAILED @"The authentication with CAS failed."
#define LOG_RETRIEVE_CONTACTS_YES @"Retrieving contacts succeeded."
#define LOG_RETRIEVE_CONTACTS_NO @"Retrieving contacts failed."
#define LOG_MERGING_YES @"Merging is done as far as we're concerned."
#define LOG_MERGING_NO @"Merging failed."
#define LOG_FIELDWORK_UPLOAD_YES @"Fieldwork upload succeeded."
#define LOG_FIELDWORK_UPLOAD_NO @"Fieldwork upload failed."

#endif
