//
//  WizardDelegate.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 04/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WizardDelegate <NSObject>
@required
- (void)wizardDidFinishWithOpEmail:(NSString *)email
                       projectName:(NSString *)name
                    organizationId:(NSInteger)organizationId;

@optional
@end
