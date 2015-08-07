//
//  AppDelegate.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/11.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "AppDelegate.h"

#import "DateManager.h"

#import "StudentInfo+Add.h"
#import "StudentLearnedWord+Add.h"
#import "StudentLearnedComponent+Add.h"


@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Sign up for User Logged In notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isLoggedIn:)
                                                 name:@"UserLoggedIn"
                                               object:nil];
    
    return YES;
}

- (void)isLoggedIn:(NSNotification*)notification
{
//    [self syncWithBmob];
}

//- (void)syncWithBmob
//{
//    [self syncStudentInfo];
//    [self syncStudentLearnedWord];
//    [self syncStudentLearnedComponent];
//}

//- (void)syncStudentInfo
//{
//    BmobQuery* query_studentInfo = [BmobQuery queryWithClassName:@"StudentInfo"];
//    NSString* studentUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentUsername"];
//    [query_studentInfo whereKey:@"studentUsername" equalTo:studentUsername];
//    [query_studentInfo findObjectsInBackgroundWithBlock:^(NSArray* match, NSError* error) {
//        if (! error) {
//            if (! match.count) {
//                NSLog(@"ERROR: Can't find StudentInfo with student username %@", studentUsername);
//                return;
//            }
//            
//            NSLog(@"SUCCESS: Fetched StudentInfo");
//            
//            BmobObject* info = [match lastObject];
//            StudentInfo* studentInfo = [StudentInfo studentInfoForStudent:studentUsername
//                                                      withTotalActiveDays:[info objectForKey:@"totalActiveDays"]
//                                                    consecutiveActiveDays:[info objectForKey:@"consecutiveActiveDays"]
//                                                         andLastActiveDay:[info objectForKey:@"lastActiveDay"]
//                                                   inManagedObjectContext:self.managedObjectContext];
//            
//            [[NSUserDefaults standardUserDefaults] setObject:studentInfo.totalActiveDays forKey:@"totalActiveDays"];
//            [[NSUserDefaults standardUserDefaults] setObject:studentInfo.consecutiveActiveDays forKey:@"consecutiveActiveDays"];
//            [[NSUserDefaults standardUserDefaults] setObject:studentInfo.lastActiveDay forKey:@"lastActiveDay"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"StudentInfoUpdated" object:self];
//            
//            [self.managedObjectContext save:&error];
//            if (! error) {
//                NSLog(@"StudentInfo saved");
//            }
//            else {
//                NSLog(@"ERROR: Error when saving StudentInfo; message: %@", error.description);
//            }
//        }
//        else {
//            NSLog(@"ERROR: Error when fetching StudentInfo; message: %@", error.description);
//        }
//    }];
//}

//- (void)syncStudentLearnedWord
//{
//    BmobQuery* query_studentLearnedWord = [BmobQuery queryWithClassName:@"StudentLearnedWord"];
//    NSString* studentUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentUsername"];
//    [query_studentLearnedWord whereKey:@"studentUsername" equalTo:studentUsername];
//    NSDate* lastSyncDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentLearnedWord_lastSyncDate"];
//    NSLog(@"Last synced: %@", lastSyncDate);
//    if (lastSyncDate) {
//        [query_studentLearnedWord whereKey:@"date" greaterThanOrEqualTo:lastSyncDate];
//    }
//    [query_studentLearnedWord setLimit:500];
//    [query_studentLearnedWord findObjectsInBackgroundWithBlock:^(NSArray* match, NSError* error) {
//        if (! error) {
//            if (! match.count) {
//                NSLog(@"No new StudentLearnedWord to be fetched");
//                return;
//            }
//            
//            NSLog(@"SUCCESS: Fetched %ld new StudentLearnedWord", match.count);
//            
//            for (BmobObject* obj in match) {
//                [StudentLearnedWord studentLearnedWordForStudent:[obj objectForKey:@"studentUsername"]
//                                                          onDate:[obj objectForKey:@"date"]
//                                                    withNewWords:[obj objectForKey:@"dailyNewWords"]
//                                                   newWordsCount:[obj objectForKey:@"dailyNewWordsCount"]
//                                                     andAllWords:[obj objectForKey:@"allWords"]
//                                                   allWordsCount:[obj objectForKey:@"allWordsCount"]
//                                          inManagedObjectContext:self.managedObjectContext];
//            }
//            
//            
//            [self.managedObjectContext save:&error];
//            if (! error) {
//                NSLog(@"StudentLearnedWord saved");
//                
//                [[NSUserDefaults standardUserDefaults] setObject:[DateManager today] forKey:@"studentLearnedWord_lastSyncDate"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"StudentInfoUpdated" object:self];
//            }
//            else {
//                NSLog(@"ERROR: Error when saving StudentLearnedWord; message: %@", error.description);
//            }
//        }
//        else {
//            NSLog(@"ERROR: Error when fetching StudentLearnedWord; message: %@", error.description);
//        }
//    }];
//}

//- (void)syncStudentLearnedComponent
//{
//    BmobQuery* query_studentLearnedComponent = [BmobQuery queryWithClassName:@"StudentLearnedComponent"];
//    NSString* studentUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentUsername"];
//    [query_studentLearnedComponent whereKey:@"studentUsername" equalTo:studentUsername];
//    NSDate* lastSyncDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentLearnedComponent_lastSyncDate"];
//    NSLog(@"Last synced: %@", lastSyncDate);
//    if (lastSyncDate) {
//        [query_studentLearnedComponent whereKey:@"date" greaterThanOrEqualTo:lastSyncDate];
//    }
//    [query_studentLearnedComponent setLimit:500];
//    [query_studentLearnedComponent findObjectsInBackgroundWithBlock:^(NSArray* match, NSError* error) {
//        if (! error) {
//            if (! match.count) {
//                NSLog(@"No new StudentLearnedComponent to be fetched");
//                return;
//            }
//            
//            NSLog(@"SUCCESS: Fetched %ld new StudentLearnedComponent", match.count);
//            
//            for (BmobObject* obj in match) {
//                [StudentLearnedComponent studentLearnedComponentForStudent:[obj objectForKey:@"studentUsername"]
//                                                                    onDate:[obj objectForKey:@"date"]
//                                                         withNewComponents:[obj objectForKey:@"dailyNewComponents"]
//                                                        newComponentsCount:[obj objectForKey:@"dailyNewComponentsCount"]
//                                                          andAllComponents:[obj objectForKey:@"allComponents"]
//                                                        allComponentsCount:[obj objectForKey:@"allComponentsCount"]
//                                                    inManagedObjectContext:self.managedObjectContext];
//            }
//            
//            
//            [self.managedObjectContext save:&error];
//            if (! error) {
//                NSLog(@"StudentLearnedComponent saved");
//                
//                [[NSUserDefaults standardUserDefaults] setObject:[DateManager today] forKey:@"studentLearnedComponent_lastSyncDate"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"StudentInfoUpdated" object:self];
//            }
//            else {
//                NSLog(@"ERROR: Error when saving StudentLearnedComponent; message: %@", error.description);
//            }
//        }
//        else {
//            NSLog(@"ERROR: Error when fetching StudentLearnedComponent; message: %@", error.description);
//        }
//    }];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.YiLi.CATGrapes.Gifted_Kids_Parent" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Gifted_Kids_Parent" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Gifted_Kids_Parent.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
