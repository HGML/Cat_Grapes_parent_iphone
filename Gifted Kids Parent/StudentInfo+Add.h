//
//  StudentInfo+Add.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "StudentInfo.h"

@interface StudentInfo (Add)

+ (StudentInfo*)studentInfoForStudent:(NSString*)username
                  withTotalActiveDays:(NSNumber*)totalActiveDays
                consecutiveActiveDays:(NSNumber*)consecutiveActiveDays
                     andLastActiveDay:(NSDate*)lastActiveDay
               inManagedObjectContext:(NSManagedObjectContext*)context;

@end
