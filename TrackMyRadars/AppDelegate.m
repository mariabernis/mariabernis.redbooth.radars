//
//  AppDelegate.m
//  TrackMyRadars
//
//  Created by Maria Bernis on 03/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "RadarListViewController.h"
#import "RedboothAPIClient.h"
#import "MBCheck.h"
#import "UIColor+TrackMyRadars.h"
// TEMP Test
#import "RadarsProject.h"

#define APP_URL_SCHEME      @"mbredbooth"
#define APP_CALLBACK_URI    @"mbredbooth://authorise"


@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self customizeAppearance];
    
    // TEMP test
//    RadarsProject *p = [[RadarsProject alloc] init];
//    p.opEmail = @"matt@bookhousesoftware.com";
//    p.radarsProjectId = 1333016;
//    p.radarsTaskListId = 2693588;
//    p.radarsProjectName = @"My named project";
//    [RadarsProject saveImportedProject:p];

    UIViewController *initialVC = [self initialViewControllerForStoryboard:[self mainStoryboard]];
    
    self.window.rootViewController = initialVC;
    [self.window makeKeyAndVisible];
    
    [MBCheck storeLastOpenedAppVersion];
    return YES;
}

- (void)customizeAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor tmrMainColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor tmrTintColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    NSDictionary *textAtt = @{ NSForegroundColorAttributeName : [UIColor tmrTintColor] };
    [[UINavigationBar appearance] setTitleTextAttributes:textAtt];
}

- (UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (UIViewController *)initialViewControllerForStoryboard:(UIStoryboard *)storyboard
{
    UIViewController *controller = nil;
    if ([RedboothAPIClient sharedInstance].isAuthorised) {
        controller = [storyboard instantiateViewControllerWithIdentifier:@"RadarListNav"];
    } else {
        controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
    }
    return controller;
}


#pragma mark - URL scheme
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"🙉 %@", url);
    if ([[url scheme] isEqualToString:APP_URL_SCHEME]) {
        NSString *urlString = [url absoluteString];
        NSString *code = [urlString substringFromIndex:[NSString stringWithFormat:@"%@?code=", APP_CALLBACK_URI].length];
        
        LoginViewController *loginVC = (LoginViewController *)self.window.rootViewController;
        [loginVC handleAuthoriseCallback:code];
        
        return YES;
    }
    return NO;
}

@end
