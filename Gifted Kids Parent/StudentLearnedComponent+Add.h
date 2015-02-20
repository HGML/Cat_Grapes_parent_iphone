//
//  StudentLearnedComponent+Add.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "StudentLearnedComponent.h"

@interface StudentLearnedComponent (Add)

+ (StudentLearnedComponent*)studentLearnedComponentForStudent:(NSString*)username
                                                       onDate:(NSDate*)date
                                            withNewComponents:(NSString*)newComponents
                                           newComponentsCount:(NSNumber*)newComponentsCount
                                             andAllComponents:(NSString*)allComponents
                                           allComponentsCount:(NSNumber*)allComponentsCount
                                       inManagedObjectContext:(NSManagedObjectContext*)context;

@end
