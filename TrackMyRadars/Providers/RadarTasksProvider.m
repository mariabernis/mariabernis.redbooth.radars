//
//  RadarTasksProvider.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "RadarTasksProvider.h"
#import "OpenradarAPIClient.h"
#import "RedboothAPIClient.h"
#import "RadarTaskParser.h"
#import "RadarTask.h"

@implementation RadarTasksProvider

- (void)fetchOpenradarsWithOPUser:(NSString *)opUser
                       completion:(void(^)(NSArray *radars, NSError *error))completion {
    
    OpenradarAPIClient *openradarClient = [OpenradarAPIClient sharedInstance];
    [openradarClient GET:OP_PATH_RADAR
              parameters:@{ @"user":opUser }
                 success:^(NSURLSessionDataTask *task, id responseObject) {
                     
                     NSArray *results = [(NSDictionary *)responseObject objectForKey:@"result"];
                     NSArray *radars = [RadarTaskParser radarTasksWithOPArray:results];
                     if (completion) {
                         completion(radars, nil);
                     }
                 }
                 failure:^(NSURLSessionDataTask *task, NSError *error) {
                     NSLog(@"😱 Error fetching radars: %@", error);
                     if (completion) {
                         completion(nil, error);
                     }
                 }];
}

- (void)postTasksForOpenradars:(NSArray *)radars
                     inProject:(NSInteger)projectId
                    inTaskList:(NSInteger)taskListId
                      progress:(void(^)(NSUInteger index, RadarTask *importedRadar))progress
                    completion:(void(^)(NSArray *importedRadars, NSError *error))completion {
    
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    
    [radars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        RadarTask *radar = (RadarTask *)obj;
        NSDictionary *taskParams = @{ @"project_id"  :@(projectId),
                                      @"task_list_id":@(taskListId),
                                      @"name"        :radar.radarTitle,
                                      @"description" :radar.radarDescription,
                                      @"is_private"  :@"false"
                                      };
        
        [redboothClient POST:RB_PATH_TASK
                  parameters:taskParams
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         NSDictionary *taskInfo = (NSDictionary *)responseObject;
                         radar.taskId = [[taskInfo objectForKey:@"id"] integerValue];
                         NSLog(@"🌠 Task imported at index %li", (unsigned long)idx);
                         if (progress) {
                             progress(idx, radar);
                         }
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         NSLog(@"😱 Error importing radar #%@: %@", radar.radarNumber, error);
                     }];
        
    }];
    
}

@end
