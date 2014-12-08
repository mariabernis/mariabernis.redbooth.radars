//
//  OrganizationParser.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Organization;
@interface OrganizationParser : NSObject

+ (NSArray *)organizationsWithJSONArray:(NSArray *)array
             atLeastOneRemainingProject:(BOOL)atLeastOne;
+ (Organization *)organizationWithJSONInfo:(NSDictionary *)info;

@end
