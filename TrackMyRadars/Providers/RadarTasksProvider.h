//
//  RadarTasksProvider.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RadarTask, RadarsProject;
@interface RadarTasksProvider : NSObject

#pragma mark - Fetching
- (void)fetchOpenradarsWithOPUser:(NSString *)opUser
                       completion:(void(^)(NSArray *radars, NSError *error))completion;
- (void)fetchRBRadarsWithProject:(RadarsProject *)project
                      completion:(void(^)(NSArray *radars, NSError *error))completion;

#pragma mark - Import batch
- (void)postTasksForOpenradars:(NSArray *)radars
                     inProject:(RadarsProject *)project
                      progress:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                        import:(void(^)(NSUInteger index, RadarTask *importedRadar, NSError *error))importBlock
                    completion:(void(^)(NSArray *importedRadars))completionBlock;
@end
