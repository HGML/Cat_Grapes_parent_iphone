//
//  AFNetworkManager.h
//  Gifted Kids Parent
//
//  Created by Yi Li on 15/8/16.
//  Copyright (c) 2015年 Yi Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface AFNetworkManager : NSObject

// Sign Up, Log In, Log Out

#define CREATE_PARENT_URL ""

#define LOGIN_URL ""

#define LOGOUT_URL ""


// Add and Get Student IDs

#define ADD_STUDENT_ID_URL ""   // Add a single student to Parents_Students

#define GET_STUDENT_IDS_URL ""   // Get all student IDs linked to a given parent


// Get Student Review Records

#define GET_STUDENT_REVIEW_RECORDS_URL ""


@end
