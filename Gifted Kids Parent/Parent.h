//
//  Parent.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/17.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Parent : NSManagedObject

@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * studentUsername;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * username;

@end
