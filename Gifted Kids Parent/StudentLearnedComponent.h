//
//  StudentLearnedComponent.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/18.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StudentLearnedComponent : NSManagedObject

@property (nonatomic, retain) NSString * studentUsername;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * allComponents;
@property (nonatomic, retain) NSNumber * allComponentsCount;
@property (nonatomic, retain) NSString * dailyNewComponents;
@property (nonatomic, retain) NSNumber * dailyNewComponentsCount;

@end
