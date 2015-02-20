//
//  StudentLearnedComponent+Add.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "StudentLearnedComponent+Add.h"

@implementation StudentLearnedComponent (Add)

+ (StudentLearnedComponent*)studentLearnedComponentForStudent:(NSString*)username
                                                       onDate:(NSDate*)date
                                            withNewComponents:(NSString*)newComponents
                                           newComponentsCount:(NSNumber*)newComponentsCount
                                             andAllComponents:(NSString*)allComponents
                                           allComponentsCount:(NSNumber*)allComponentsCount
                                       inManagedObjectContext:(NSManagedObjectContext*)context
{
    StudentLearnedComponent* slc = nil;
    
    // Check for duplicates
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"StudentLearnedComponent"];
    request.predicate = [NSPredicate predicateWithFormat:@"studentUsername == %@ && date == %@ && dailyNewComponents == %@ && dailyNewComponentsCount == %@ && allComponents == %@ && allComponentsCount == %@", username, date, newComponents, newComponentsCount, allComponents, allComponentsCount];
    NSError* error = nil;
    NSArray* match = [context executeFetchRequest:request error:&error];
    
    if (! match || match.count > 1) {
        NSLog(@"ERROR: Error when fetching StudentLearnedComponent");
        NSLog(@"\tmatch = %@", match);
    }
    else if (match.count == 1) {
        slc = [match lastObject];
    }
    else {
        slc = [NSEntityDescription insertNewObjectForEntityForName:@"StudentLearnedComponent"
                                            inManagedObjectContext:context];
        slc.studentUsername = username;
        slc.date = date;
        slc.dailyNewComponents = newComponents;
        slc.dailyNewComponentsCount = newComponentsCount;
        slc.allComponents = allComponents;
        slc.allComponentsCount = allComponentsCount;
    }
    
    return slc;
}

@end
