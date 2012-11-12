//
//  MDESCodeGetRequest.h
//  NCSNavField
//
//  Created by Sam Hicks on 11/6/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface MDESCodeGetRequest : NSObject<RKObjectLoaderDelegate> {
    CasServiceTicket* _ticket;
    NSString* _error;
    RKResponse* _response;
}

@property(nonatomic,strong) CasServiceTicket* ticket;
@property(nonatomic,strong) NSString* error;
@property(nonatomic,strong) RKResponse* response;

- (id)initWithServiceTicket:(CasServiceTicket*)ticket;
- (BOOL)send;
- (BOOL)isSuccessful;
- (void)loadDataWithProxyTicket:(CasProxyTicket*)ticket;
- (void)retrieveCodes:(CasProxyTicket*)pt;
- (void)showErrorMessage:(NSString *)message;
- (NSURL*)resourceURL;
@end
