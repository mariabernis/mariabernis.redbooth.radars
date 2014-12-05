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

+ (NSArray *)radarTasksWithOPArray:(NSArray *)array;
+ (RadarTask *)radarTaskWithOPInfo:(NSDictionary *)info;
+ (NSDictionary *)rbParametersWithRadarTask:(RadarTask *)radar
                            andRadarProject:(RadarsProject *)project;
+ (NSArray *)radarTasksWithRBArray:(NSArray *)array;

@end
