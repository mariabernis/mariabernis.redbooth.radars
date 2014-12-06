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
                     
                     NSLog(@"😱 Error fetching openradars: %@", error);
                     if (completion) {
                         completion(nil, error);
                     }
                 }];
}

- (void)fetchRBRadarsWithProject:(RadarsProject *)project
                      completion:(void(^)(NSArray *radars, NSError *error))completion {
    
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    
    NSDictionary *tasksParams = [RadarTaskParser rbGetTasksParametersWithProject:project];
    [redboothClient GET:RB_PATH_TASK
             parameters:tasksParams
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    NSArray *results = (NSArray *)responseObject;
                    NSArray *radarTasks = [RadarTaskParser radarTasksWithRBArray:results];
                    if (completion) {
                        completion(radarTasks, nil);
                    }
                }
                failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                    NSLog(@"😱 Error fetching rb tasks: %@", error);
                    if (completion) {
                        completion(nil, error);
                    }
                }];
}

- (void)postTasksForOpenradars:(NSArray *)radars
                     inProject:(RadarsProject *)project
                      progress:(void(^)(NSUInteger index, RadarTask *importedRadar))progress
                    completion:(void(^)(NSArray *importedRadars, NSError *error))completion {
    
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    
    NSInteger total = radars.count;
    __block NSInteger completed = 0;
    __block NSMutableArray *imported = [[NSMutableArray alloc] init];
    [radars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        RadarTask *radar = (RadarTask *)obj;
        NSDictionary *taskParams = [RadarTaskParser rbPostTaskParametersWithRadarTask:radar
                                                                      andRadarProject:project];
        
        [redboothClient POST:RB_PATH_TASK
                  parameters:taskParams
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         
                         NSDictionary *taskInfo = (NSDictionary *)responseObject;
                         RadarTask *importedRadar = [RadarTaskParser radarTaskWithRBInfo:taskInfo];
                         importedRadar.radarNumber = radar.radarNumber;
                         NSLog(@"🌠 Task imported at index %li", (unsigned long)idx);
                         completed ++;
                         [imported addObject:importedRadar];
                         
                         if (progress) {
                             progress(idx, radar);
                         }
                         if (completed == total) {
                             if (completion) {
                                 completion(imported, nil);
                             }
                         }
                     }
                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                         
                         NSLog(@"😱 Error importing radar #%@: %@", radar.radarNumber, error);
                         completed ++;
                         if (completed == total) {
                             if (completion) {
                                 completion(nil, error);
                             }
                         }
                     }];
        
    }];
    
}

@end
