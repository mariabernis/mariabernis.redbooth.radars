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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    UIViewController *initialVC = [self initialViewControllerForStoryboard:[self mainStoryboard]];
    
    self.window.rootViewController = initialVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (UIStoryboard *)mainStoryboard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

- (UIViewController *)initialViewControllerForStoryboard:(UIStoryboard *)storyboard {
    UIViewController *controller = nil;
    if ([[RedboothAPIClient sharedInstance] hasStoredToken]) {
        controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([RadarListViewController class])];
    } else {
        controller = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
    }
    return controller;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"😱😱😱😱 %@", url);
    if ([[url scheme] isEqualToString:APP_URL_SCHEME]) {
        NSString *urlString = [url absoluteString];
        NSString *urlParams = [urlString substringFromIndex:[APP_CALLBACK_URI length] + 1];
        [[RedboothAPIClient sharedInstance] authorisedWithCallback:urlParams];
        
        UIViewController *initialVC = [self initialViewControllerForStoryboard:[self mainStoryboard]];
        
        self.window.rootViewController = initialVC;
        [self.window makeKeyAndVisible];
        
        
        return YES;
    }
    return NO;
}

@end
