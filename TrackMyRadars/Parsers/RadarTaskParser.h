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

#pragma mark - Openradar 
// Openradar fetch
+ (NSArray *)radarTasksWithOPArray:(NSArray *)array;
+ (RadarTask *)radarTaskWithOPInfo:(NSDictionary *)info;
+ (NSString *)addRadarNumber:(NSString *)radarNumber toDescription:(NSString *)description;

#pragma mark - Redbooth
// Redbooth fetch
+ (NSArray *)radarTasksWithRBArray:(NSArray *)array;
+ (RadarTask *)radarTaskWithRBInfo:(NSDictionary *)info;
+ (NSString *)retrieveRadarNumberFromDescription:(NSString *)description;

+ (NSDictionary *)rbGETTasksParametersWithProject:(RadarsProject *)project;

// Redbooth post
+ (NSDictionary *)rbPOSTTaskParametersWithRadarTask:(RadarTask *)radar
                                    andRadarProject:(RadarsProject *)project;
@end
