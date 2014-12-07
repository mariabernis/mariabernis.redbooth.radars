//
//  RadarsProject.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 05/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadarsProject : NSObject

@property (nonatomic, strong) NSString *opEmail;
@property (nonatomic, strong) NSString *radarsProjectName;
@property (nonatomic, assign) NSInteger radarsProjectId;
@property (nonatomic, assign) NSInteger radarsTaskListId;

+ (RadarsProject *)importedProject;
+ (BOOL)saveImportedProject:(RadarsProject *)project;

@end
