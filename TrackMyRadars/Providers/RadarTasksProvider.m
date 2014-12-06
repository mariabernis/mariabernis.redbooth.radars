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
                      progress:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                        import:(void(^)(NSUInteger index, RadarTask *importedRadar, NSError *error))importBlock
                    completion:(void(^)(NSArray *importedRadars))completionBlock {
    
    NSMutableArray *mOperations = [[NSMutableArray alloc] init];
    
    __block NSMutableArray *importedRadars = [[NSMutableArray alloc] init];
    [radars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        RadarTask *radar = (RadarTask *)obj;
        AFHTTPRequestOperation *operation = [self operationForPostingRadar:radar inRadarProject:project];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *taskInfo = (NSDictionary *)responseObject;
            RadarTask *importedRadar = [RadarTaskParser radarTaskWithRBInfo:taskInfo];
            importedRadar.radarNumber = radar.radarNumber;
            [importedRadars addObject:importedRadar];
            NSLog(@"🌠 Task imported at index %li", (unsigned long)idx);
            if (importBlock) {
                importBlock(idx, importedRadar, nil);
            }
        }
        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"😱 Error importing radar #%@: %@", radar.radarNumber, error);
            if (importBlock) {
                importBlock(idx, nil, error);
            }
        }];
        
        [mOperations addObject:operation];
        
    }];
    
    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"🌠 %lu of %lu complete", numberOfFinishedOperations, totalNumberOfOperations);
        if (progressBlock) {
            progressBlock(numberOfFinishedOperations, totalNumberOfOperations);
        }
    } completionBlock:^(NSArray *operations) {
        NSLog(@"🌠 All operations in batch complete");
        if (completionBlock) {
            completionBlock(importedRadars);
        }
    }];
    
    [[RedboothAPIClient sharedInstance].operationQueue addOperations:operations waitUntilFinished:NO];
    
}

- (AFHTTPRequestOperation *)operationForPostingRadar:(RadarTask *)radar inRadarProject:(RadarsProject *)project {
    
    RedboothAPIClient *redboothClient = [RedboothAPIClient sharedInstance];
    NSString *path = [[NSURL URLWithString:RB_PATH_TASK relativeToURL:redboothClient.baseURL] absoluteString];
    NSDictionary *taskParams = [RadarTaskParser rbPostTaskParametersWithRadarTask:radar
                                                                  andRadarProject:project];
    
    NSMutableURLRequest *request = [redboothClient.requestSerializer requestWithMethod:@"POST"
                                                                             URLString:path
                                                                            parameters:taskParams
                                                                                 error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = redboothClient.responseSerializer;
    operation.securityPolicy = redboothClient.securityPolicy;
    
    return operation;
}

@end
