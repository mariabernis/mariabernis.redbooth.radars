//
//  RadarsProjectProvider.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarsProjectProvider.h"
#import "RedboothAPIClient.h"
#import "RadarsProjectParser.h"
#import "RadarsProject.h"

@interface RadarsProjectProvider ()
@property (nonatomic, strong) NSString *opEmail;
@property (nonatomic, strong) NSString *projectName;
@end


@implementation RadarsProjectProvider

- (instancetype)initWithOpUser:(NSString *)email projectName:(NSString *)name
{
    self = [super init];
    if (self) {
        _opEmail = email;
        _projectName = name;
    }
    return self;
}

- (void)newRadarsProjectWithName:(NSString *)name
                  organizationId:(NSInteger)organizationId
                      completion:(void(^)(RadarsProject *project, NSError *error))completion {
    
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    NSDictionary *projectParams = [RadarsProjectParser rbProjectParametersWithName:name
                                                                    organizationId:organizationId];
    
    [redboothClient POST:RB_PATH_PROJECT
              parameters:projectParams
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     
                     NSDictionary *projInfo = (NSDictionary *)responseObject;
                     NSInteger projId = [RadarsProjectParser projectIdWithJSONInfo:projInfo];
                     NSDictionary *taskListParams = [RadarsProjectParser rbTasklistParametersWithProjectId:projId];
                     
                     [redboothClient GET:RB_PATH_TASKLIST
                              parameters:taskListParams
                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                     
                                     NSDictionary *taskListInfo = [(NSArray *)responseObject firstObject];
                                     RadarsProject *project = [RadarsProjectParser projectWithOpUser:self.opEmail
                                                                                         projectName:self.projectName
                                                                                  rbTasklistJSONInfo:taskListInfo];
                                     BOOL saved = [RadarsProject saveImportedProject:project];
                                     NSLog(@"🌠 Project created and saved: %@", saved? @"YES" : @"NO");
                                     completion(project, nil);
                                 }
                                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     NSLog(@"😱 Error getting tasklist: %@", error);
                                     completion(nil, error);
                                 }];
                     
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     
                     NSLog(@"😱 Error creating project: %@", error);
                     completion(nil, error);
                 }];
}

@end
