//
//  ParentUser.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/18.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ParentUser : NSObject

@property (nonatomic, strong) NSString* studentUsername;

/**
 *	设置用户名
 *
 *	@param	username	提供的用户名
 */
-(void)setStudentUsername:(NSString*)studentUsername;

@end
