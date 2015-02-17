//
//  StudentLearnedWord+Add.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "StudentLearnedWord.h"

@interface StudentLearnedWord (Add)

+ (StudentLearnedWord*)studentLearnedWordForStudent:(NSString*)username
                                             onDate:(NSDate*)date
                                       withNewWords:(NSString*)newWords
                                      newWordsCount:(NSNumber*)newWordsCount
                                        andAllWords:(NSString*)allWords
                                      allWordsCount:(NSNumber*)allWordsCount
                             inManagedObjectContext:(NSManagedObjectContext*)context;

@end
