//
//  RadarTaskParser.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RadarTask, RadarsProject;
@interface RadarTaskParser : NSObject

// Openradar fetch
+ (NSArray *)radarTasksWithOPArray:(NSArray *)array;
+ (RadarTask *)radarTaskWithOPInfo:(NSDictionary *)info;

// Redbooth fetch
+ (NSArray *)radarTasksWithRBArray:(NSArray *)array;
+ (RadarTask *)radarTaskWithRBInfo:(NSDictionary *)info;

+ (NSDictionary *)rbGetTasksParametersWithProject:(RadarsProject *)project;

// Redbooth post
+ (NSDictionary *)rbPostTaskParametersWithRadarTask:(RadarTask *)radar
                                    andRadarProject:(RadarsProject *)project;
@end
