//
//  UIView+Additions.h
//  NCSNavField
//
//  Created by Sam Hicks on 10/26/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)
-(void)postPopoverNotification;
-(void)registerForPopoverNotifications;
-(void)dismissKeyboard;
//Will return nil if the subview is not found. Clients need to check for this.
-(UIView*)subviewWithTag:(NSUInteger)i;
@end
