//
//  StudentInfo+Add.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "StudentInfo+Add.h"

@implementation StudentInfo (Add)

+ (StudentInfo*)studentInfoForStudent:(NSString*)username
                  withTotalActiveDays:(NSNumber*)totalActiveDays
                consecutiveActiveDays:(NSNumber*)consecutiveActiveDays
                     andLastActiveDay:(NSDate*)lastActiveDay
               inManagedObjectContext:(NSManagedObjectContext*)context
{
    StudentInfo* info = nil;
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"StudentInfo"];
    request.predicate = [NSPredicate predicateWithFormat:@"studentUsername == %@", username];
    NSError* error = nil;
    NSArray* match = [context executeFetchRequest:request error:&error];
    
    // If StudentInfo exists for username: update
    // Else: create row
    if (match.count == 1) {
        info = [match lastObject];
    }
    else {
        info = [NSEntityDescription insertNewObjectForEntityForName:@"StudentInfo"
                                            inManagedObjectContext:context];
    }
    
    info.studentUsername = username;
    info.totalActiveDays = totalActiveDays;
    info.consecutiveActiveDays = consecutiveActiveDays;
    info.lastActiveDay = lastActiveDay;
    
    return info;
}

@end
