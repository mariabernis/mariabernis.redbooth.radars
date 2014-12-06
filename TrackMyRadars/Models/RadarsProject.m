//
//  RadarsProject.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 05/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarsProject.h"

#define KEY_IMPORTED_PROJECT @"openradar_to_redbooth_proj"
#define KEY_OP_EMAIL         @"imported_op_email"
#define KEY_RB_PROJECT_ID    @"imported_proj_id"
#define KEY_RB_TASKLIST_ID   @"imported_tasklist_id"


@implementation RadarsProject

+ (RadarsProject *)importedProject {
    RadarsProject *project = nil;
    NSDictionary *projInfo = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_IMPORTED_PROJECT];
    if (projInfo) {
        project = [[RadarsProject alloc] init];
        project.opEmail = [projInfo objectForKey:KEY_OP_EMAIL];
        project.radarsProjectId = [[projInfo objectForKey:KEY_RB_PROJECT_ID] integerValue];
        project.radarsTaskListId = [[projInfo objectForKey:KEY_RB_TASKLIST_ID] integerValue];
    }
    return project;
}

+ (BOOL)saveImportedProject:(RadarsProject *)project{

    if (project.opEmail == nil || project.radarsProjectId == 0) {
        return NO;
    }
    
    NSDictionary *projInfo = @{ KEY_OP_EMAIL      : project.opEmail,
                                KEY_RB_PROJECT_ID : @(project.radarsProjectId),
                                KEY_RB_TASKLIST_ID: @(project.radarsTaskListId)
                                };
    [[NSUserDefaults standardUserDefaults] setObject:projInfo forKey:KEY_IMPORTED_PROJECT];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return YES;
}

@end
