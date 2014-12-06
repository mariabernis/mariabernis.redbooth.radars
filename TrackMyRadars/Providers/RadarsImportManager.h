//
//  RadarsImportManager.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RadarTask;
@interface RadarsImportManager : NSObject

/* Designated initializer */
- (instancetype)initWithOpEmail:(NSString *)opEmail andOrganizationId:(NSInteger)organizationId;

- (void)importRadarsWithTemporaryContent:(void(^)(NSArray *tempRadars))tempContent
                                progress:(void(^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                                  import:(void(^)(NSUInteger index, RadarTask *importedRadar, NSError *error))importBlock
                              completion:(void(^)(NSArray *importedRadars, NSError *error))completionBlock;
@end
