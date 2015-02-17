//
//  StudentStartedSession.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StudentStartedSession : NSManagedObject

@property (nonatomic, retain) NSNumber * isOnTime;
@property (nonatomic, retain) NSNumber * isReminded;
@property (nonatomic, retain) NSDate * scheduledTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * studentUsername;

@end
