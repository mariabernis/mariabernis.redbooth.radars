//
//  RadarsProjectProvider.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarsProjectProvider.h"
#import "RedboothAPIClient.h"

@implementation RadarsProjectProvider

- (void)newRadarsProjectWithOrganizationId:(NSInteger)organizationId
                                completion:(void(^)(NSInteger projectId, NSInteger taskListId, NSError *error))completion {
    
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    NSDictionary *projectParams = @{ @"name"           :@"Open radars",
                                     @"organization_id":@(organizationId),
                                     @"publish_pages"  :@"false"
                                     };
    
    [redboothClient POST:RB_PATH_PROJECT
              parameters:projectParams
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     
                     NSDictionary *projInfo = (NSDictionary *)responseObject;
                     NSInteger projId = [[projInfo objectForKey:@"id"] integerValue];
//                     @{ @"project_id":@(projId) }
                     [redboothClient GET:RB_PATH_TASKLIST
                              parameters:@{ @"project_id":@(projId) }
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     
                                     NSDictionary *taskListInfo = [(NSArray *)responseObject firstObject];
                                     NSInteger taskListId = [[taskListInfo objectForKey:@"id"] integerValue];
                                     
                                     NSLog(@"🌠 Project created %li", (long)projId);
                                     completion(projId, taskListId, nil);
                                 }
                                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     NSLog(@"😱 Error getting tasklist: %@", error);
                                     completion(0, 0, error);
                                 }];
                     
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     NSLog(@"😱 Error creating project: %@", error);
                     completion(0, 0, error);
                 }];
}

@end
