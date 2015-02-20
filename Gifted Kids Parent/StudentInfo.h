//
//  StudentInfo.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/18.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StudentInfo : NSManagedObject

@property (nonatomic, retain) NSString * studentUsername;
@property (nonatomic, retain) NSNumber * totalActiveDays;
@property (nonatomic, retain) NSNumber * consecutiveActiveDays;
@property (nonatomic, retain) NSDate * lastActiveDay;

@end
