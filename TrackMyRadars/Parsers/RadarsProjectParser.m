//
//  RadarsProjectParser.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 06/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarsProjectParser.h"
#import "RadarsProject.h"
#import "MBCheck.h"

@implementation RadarsProjectParser

#pragma mark - Openradar
+ (RadarsProject *)projectWithOpUser:(NSString *)email
                         projectName:(NSString *)name
                  rbTasklistJSONInfo:(NSDictionary *)tasklistInfo
{
    RadarsProject *item = [[RadarsProject alloc] init];
    item.opEmail = email;
    item.radarsProjectName = name;
    item.radarsProjectId = [[tasklistInfo objectForKey:@"project_id"] integerValue];
    item.radarsTaskListId = [[tasklistInfo objectForKey:@"id"] integerValue];

    return item;
}

#pragma mark - Redbooth
+ (NSInteger)projectIdWithJSONInfo:(NSDictionary *)info
{
    return [[info objectForKey:@"id"] integerValue];
}

+ (NSDictionary *)rbProjectParametersWithName:(NSString *)name organizationId:(NSInteger)organizationId
{
    if ([MBCheck isEmpty:name]) {
        name = @"Track My Radars";
    }
    NSDictionary *params = @{ @"name"           :name,
                              @"organization_id":@(organizationId),
                              @"publish_pages"  :@"false"
                              };
    return params;
}

+ (NSDictionary *)rbTasklistParametersWithProjectId:(NSInteger)projectId
{
    NSDictionary *params = @{ @"project_id":@(projectId) };
    return params;
}

@end
