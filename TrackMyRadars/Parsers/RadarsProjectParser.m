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

+ (NSInteger)projectIdWithJSONInfo:(NSDictionary *)info {
    
    return [[info objectForKey:@"id"] integerValue];
}

+ (RadarsProject *)projectWithOpUser:(NSString *)email rbTasklistJSONInfo:(NSDictionary *)tasklistInfo {
    
    RadarsProject *item = [[RadarsProject alloc] init];
    item.opEmail = email;
    item.radarsProjectId = [[tasklistInfo objectForKey:@"project_id"] integerValue];
    item.radarsTaskListId = [[tasklistInfo objectForKey:@"id"] integerValue];

    return item;
}

+ (NSDictionary *)rbProjectParametersWithName:(NSString *)name organizationId:(NSInteger)organizationId {
    
    if ([MBCheck isEmpty:name]) {
        name = @"Track My Radars";
    }
    NSDictionary *params = @{ @"name"           :name,
                              @"organization_id":@(organizationId),
                              @"publish_pages"  :@"false"
                              };
    return params;
}

+ (NSDictionary *)rbTasklistParametersWithProjectId:(NSInteger)projectId {
    
    NSDictionary *params = @{ @"project_id":@(projectId) };
    return params;
}

@end
