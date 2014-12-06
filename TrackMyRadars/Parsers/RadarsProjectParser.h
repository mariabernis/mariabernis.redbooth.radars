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

+ (NSInteger)projectIdWithJSONInfo:(NSDictionary *)info;
+ (RadarsProject *)projectWithOpUser:(NSString *)email rbTasklistJSONInfo:(NSDictionary *)tasklistInfo;
+ (NSDictionary *)rbParametersWithOrganizationId:(NSInteger)organizationId;
+ (NSDictionary *)rbTasklistParametersWithProjectId:(NSInteger)projectId;

@end
