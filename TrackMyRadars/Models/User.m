//
//  User.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "User.h"

#define KEY_STORED_USER   @"trackradars_user"
#define KEY_OP_EMAIL      @"user_op_email"
#define KEY_RB_PROJECT_ID @"user_rb_project_id"

@implementation User

+ (User *)storedUser {
    User *user = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_STORED_USER];
    if (userInfo) {
        user = [[User alloc] init];
        user.opEmail = [userInfo objectForKey:KEY_OP_EMAIL];
        user.radarsProjectId = [[userInfo objectForKey:KEY_RB_PROJECT_ID] integerValue];
    }
    return user;
}

+ (BOOL)saveUser:(User *)user {

    if (user.opEmail == nil || user.radarsProjectId == 0) {
        return NO;
    }
    
    NSDictionary *userInfo = @{ KEY_OP_EMAIL      : user.opEmail,
                                KEY_RB_PROJECT_ID : @(user.radarsProjectId)
                               };
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:KEY_STORED_USER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

@end
