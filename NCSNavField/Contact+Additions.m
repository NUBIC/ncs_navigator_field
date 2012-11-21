//
//  Contact+Additions.m
//  NCSNavField
//
//  Created by Sam Hicks on 11/20/12.
//  Copyright (c) 2012 Northwestern University. All rights reserved.
//

#import "Contact+Additions.h"

@implementation Contact (Additions)
-(BOOL)onSameDay:(Contact*)c {
    NSDate *myDate,*yourDate;
    NSDateComponents *myComponents,*yourComponents;
    myDate = self.date;
    yourDate = c.date;
    NSCalendar *cal = [NSCalendar currentCalendar];
    myComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:myDate];
    yourComponents = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:yourDate];
    if((myComponents.month == yourComponents.month)&&([myComponents year]==[yourComponents year])&&([myComponents day]==[yourComponents day]))
    {
        return TRUE;
    }
    return FALSE;
}
@end
