//
//  User.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic, strong) NSString *opEmail;
@property (nonatomic, assign) NSInteger radarsProjectId;

+ (User *)storedUser;
+ (BOOL)saveUser:(User *)user;

@end
