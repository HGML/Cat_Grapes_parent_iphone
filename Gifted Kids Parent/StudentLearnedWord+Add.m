//
//  StudentLearnedWord+Add.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "StudentLearnedWord+Add.h"

@implementation StudentLearnedWord (Add)

+ (StudentLearnedWord*)studentLearnedWordForStudent:(NSString*)username
                                             onDate:(NSDate*)date
                                       withNewWords:(NSString*)newWords
                                      newWordsCount:(NSNumber*)newWordsCount
                                        andAllWords:(NSString*)allWords
                                      allWordsCount:(NSNumber*)allWordsCount
                             inManagedObjectContext:(NSManagedObjectContext*)context
{
    StudentLearnedWord* slw = nil;
    
    // Check for duplicates
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"StudentLearnedWord"];
    request.predicate = [NSPredicate predicateWithFormat:@"studentUsername == %@ && date == %@ && dailyNewWords == %@ && dailyNewWordsCount == %@ && allWords == %@ && allWordsCount == %@", username, date, newWords, newWordsCount, allWords, allWordsCount];
    NSError* error = nil;
    NSArray* match = [context executeFetchRequest:request error:&error];
    
    if (! match || match.count > 1) {
        NSLog(@"ERROR: Error when fetching StudentLearnedWord");
        NSLog(@"\tmatch = %@", match);
    }
    else if (match.count == 1) {
        slw = [match lastObject];
    }
    else {
        slw = [NSEntityDescription insertNewObjectForEntityForName:@"StudentLearnedWord"
                                            inManagedObjectContext:context];
        slw.studentUsername = username;
        slw.date = date;
        slw.dailyNewWords = newWords;
        slw.dailyNewWordsCount = newWordsCount;
        slw.allWords = allWords;
        slw.allWordsCount = allWordsCount;
    }
    
    return slw;
}

@end
