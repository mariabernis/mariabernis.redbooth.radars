//
//  OrganizationsProvider.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganizationsProvider : NSObject
- (void)fetchOrganizationsWithRemainingProjects:(void(^)(NSArray *organizations, NSError * error))completion;
@end
