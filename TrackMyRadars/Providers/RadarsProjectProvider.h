//
//  RadarsProjectProvider.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RadarsProjectProvider : NSObject

- (void)newRadarsProjectWithOrganizationId:(NSInteger)organizationId
                                completion:(void(^)(NSInteger projectId, NSInteger taskListId, NSError *error))completion;

@end
