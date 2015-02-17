//
//  StudentLearnedWord.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StudentLearnedWord : NSManagedObject

@property (nonatomic, retain) NSString * studentUsername;
@property (nonatomic, retain) NSString * allWords;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * dailyNewWords;
@property (nonatomic, retain) NSNumber * allWordsCount;
@property (nonatomic, retain) NSNumber * dailyNewWordsCount;

@end
