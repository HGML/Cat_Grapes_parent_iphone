//
//  Sentence.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudentDidExercise;

@interface Sentence : NSManagedObject

@property (nonatomic, retain) NSString * chinese;
@property (nonatomic, retain) NSString * english;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) StudentDidExercise *isDifficultInExercise;

@end
