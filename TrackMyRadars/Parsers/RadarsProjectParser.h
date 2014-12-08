//
//  RadarsProjectParser.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 06/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RadarsProject;
@interface RadarsProjectParser : NSObject

#pragma mark - Openradar
+ (RadarsProject *)projectWithOpUser:(NSString *)email
                         projectName:(NSString *)name
                  rbTasklistJSONInfo:(NSDictionary *)tasklistInfo;

#pragma mark - Redbooth
+ (NSInteger)projectIdWithJSONInfo:(NSDictionary *)info;
+ (NSDictionary *)rbProjectParametersWithName:(NSString *)name organizationId:(NSInteger)organizationId;
+ (NSDictionary *)rbTasklistParametersWithProjectId:(NSInteger)projectId;

@end
