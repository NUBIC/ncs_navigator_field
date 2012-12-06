//
//  PushFieldworkStep.m
//  NCSNavField
//
//  Created by John Dzak on 4/24/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "FieldworkPutRequest.h"
#import "ApplicationSettings.h"
#import "Fieldwork.h"
#import "MergeStatus.h"
#import "CasServiceTicket+Additions.h"
#import "FieldworkSynchronizationException.h"

@implementation FieldworkPutRequest

@synthesize ticket = _ticket;

@synthesize error = _error;

@synthesize response = _response;
@synthesize userAlertDelegate = _userAlertDelegate;
@synthesize loggingDelegate = _loggingDelegate;

- (id) initWithServiceTicket:(CasServiceTicket*)ticket {
    self = [super init];
    if (self) {
        _ticket = ticket;
    }
    return self;
}

- (BOOL) send {
    //We can also use this. I'm not 100% sure that this is the best solution, but it would be nice to save coding and have a single point
    //where this functionality is handled (easier when we want to make changes.) (See the one line directly below.)
    NSString *str;
    CasProxyTicket *pt = [self.ticket obtainProxyTicket:&str];
    if(self.error) {
        [_userAlertDelegate showAlertView:CAS_TICKET_RETRIEVAL];
        [_loggingDelegate addLine:LOG_AUTH_FAILED];
        [_loggingDelegate addLine:@"With Info:"];
        [_loggingDelegate addLine:self.error];
        FieldworkSynchronizationException *exServerDown = [[FieldworkSynchronizationException alloc] initWithName:@"CAS Server is down" reason:@"Server is down" userInfo:nil];
        @throw exServerDown;
    }
        
    return [self send:pt];
}

- (BOOL) isSuccessful {
    return !(self.error && [self.error length] > 0);
}

- (BOOL)send:(CasProxyTicket*)proxyTicket {
    if (proxyTicket) {
        Fieldwork* submission = [Fieldwork submission];
        if (submission) {
            RKObjectManager *objectManager = [self objectManager:proxyTicket];
            RKObjectLoader* loader = [self objectLoader:submission objectManager:objectManager];
            self.response = [loader sendSynchronously];
            [_loggingDelegate addLine:[NSString stringWithFormat:@"Put response has location header: %@", self.response.location]];
            NSLog(@"Put response has location header: %@", self.response.location);
            [_loggingDelegate addLine:[NSString stringWithFormat:@"Response status code: %d", [self.response statusCode]]];
            NCSLog(@"Response status code: %d", [self.response statusCode]);
        }
    }
    return [self isSuccessful];
}

- (RKObjectManager *)objectManager:(CasProxyTicket *)proxyTicket {
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager.client.HTTPHeaders setValue:[NSString stringWithFormat:@"CasProxy %@", proxyTicket.proxyTicket] forKey:@"Authorization"];
    [objectManager.client.HTTPHeaders setValue:ApplicationSettings.instance.clientId forKey:@"X-Client-ID"];
    return objectManager;
}

- (RKObjectLoader *)objectLoader:(Fieldwork *)submission objectManager:(RKObjectManager *)objectManager {
    // TODO: Serialize data and then use RKRequest so objectLoader isn't 
    // invoked when data is returned
    
    NSString* path = [NSString stringWithFormat:@"/api/v1/fieldwork/%@", submission.fieldworkId];
    
    NCSLog(@"PUT %@", path);
     [_loggingDelegate addLine:[NSString stringWithFormat:@"Put: %@", path]];
    RKObjectLoader* loader = [objectManager objectLoaderForObject:submission method:RKRequestMethodPUT delegate:self];
    loader.resourcePath = path;
    
    return loader;
}

- (NSString*) mergeStatusId {
    return [MergeStatus mergeStatusIdFromUri:self.response.location];
}

#pragma mark - 
#pragma RKDelegate


- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    // We're only showing an error if the response failed because
    // upon success Cases will return a response with the body
    // {"success":true}, which is unmappable and causes RestKit to
    // throw an error.
    if (!objectLoader.response.isSuccessful) {
        [_loggingDelegate addLine:LOG_FIELDWORK_UPLOAD_NO];
        NCSLog(@"Error: Localized Description: %@", [error localizedDescription]);
        NCSLog(@"Error: Underlying Error: %@", [error.userInfo valueForKey:NSUnderlyingErrorKey]);
        [_loggingDelegate addLine:[NSString stringWithFormat:@"Error: Localized Description: %@", [error localizedDescription]]];
        [_loggingDelegate addLine:[NSString stringWithFormat:@"Error: Underlying Error: %@", [error.userInfo valueForKey:NSUnderlyingErrorKey]]];
        self.error = [NSString stringWithFormat:@"Error while pushing fieldwork.\n%@", [error localizedDescription]];
        [_userAlertDelegate showAlertView:PUTTING_DATA_ON_SERVER];
        FieldworkSynchronizationException *exServerDown = [[FieldworkSynchronizationException alloc] initWithName:self.error reason:nil userInfo:nil];
        @throw exServerDown;
    }
}

- (void)objectLoaderDidFinishLoading:(RKObjectLoader*)objectLoader {
    //[_delegate showAlertView:@"the fieldwork step"];
}



@end
