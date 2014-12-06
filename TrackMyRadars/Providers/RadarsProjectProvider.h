//
//  RadarsProjectProvider.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RadarsProject;
@interface RadarsProjectProvider : NSObject

/* Designated initializer */
- (instancetype)initWithOpUser:(NSString *)email;

- (void)newRadarsProjectWithOrganizationId:(NSInteger)organizationId
                                completion:(void(^)(RadarsProject *project, NSError *error))completion;

@end
