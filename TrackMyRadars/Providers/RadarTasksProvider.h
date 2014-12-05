//
//  RadarTasksProvider.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RadarTask;
@interface RadarTasksProvider : NSObject

- (void)fetchOpenradarsWithOPUser:(NSString *)opUser
                       completion:(void(^)(NSArray *radars, NSError *error))completion;
- (void)postTasksForOpenradars:(NSArray *)radars
                     inProject:(NSInteger)projectId
                    inTaskList:(NSInteger)taskListId
                      progress:(void(^)(NSUInteger index, RadarTask *importedRadar))progress
                    completion:(void(^)(NSArray *importedRadars, NSError *error))completion;
@end
