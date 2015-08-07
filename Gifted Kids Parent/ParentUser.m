//
//  ParentUser.m
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/2/18.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import "ParentUser.h"

@implementation ParentUser

@synthesize studentUsername = _studentUsername;

/**
 *	设置用户名
 *
 *	@param	username	提供的用户名
 */
-(void)setStudentUsername:(NSString*)studentUsername
{
    _studentUsername = studentUsername;
}

@end
