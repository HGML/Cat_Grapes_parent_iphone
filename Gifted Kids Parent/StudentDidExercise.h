//
//  StudentDidExercise.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StudentDidExercise : NSManagedObject

@property (nonatomic, retain) NSString * difficultWords;
@property (nonatomic, retain) NSNumber * exerciseUid;
@property (nonatomic, retain) NSNumber * isReview;
@property (nonatomic, retain) NSString * learnedComponents;
@property (nonatomic, retain) NSString * learnedWords;
@property (nonatomic, retain) NSString * reviewedComponents;
@property (nonatomic, retain) NSString * reviewedWords;
@property (nonatomic, retain) NSString * studentUsername;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSManagedObject *hasDifficultSentences;

@end
