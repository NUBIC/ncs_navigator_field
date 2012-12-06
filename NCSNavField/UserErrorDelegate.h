//
//  UserErrorDelegate.h
//  NCSNavField
//
//  Created by Sam Hicks on 12/5/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserErrorDelegate <NSObject>
@required
-(void)showAlertView:(NSString*)strError;
-(void)setHUDMessage:(NSString*)strMessage;
-(void)setHUDMessage:(NSString*)strMessage andDetailMessage:(NSString*)detailMessage;
-(void)setHUDMessage:(NSString*)strMessage withFontSize:(CGFloat)f;
-(void)hideHUD;
@optional
-(void)setHUDMessage:(NSString*)strMessage andDetailMessage:(NSString*)detailMessage withMajorFontSize:(CGFloat)f;
-(void)setHUDMessage:(NSString*)strMessage andDetailMessage:(NSString*)detailMessage withMajorFontSize:(CGFloat)f andMinorFontSize:(CGFloat)g;
//We should include more options to show the user additional stuff. This
//will suffice for now.
@end

