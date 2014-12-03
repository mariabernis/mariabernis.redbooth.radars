//
//  RedboothAPIClient.h
//  TrackMyRadars
//
//  Created by Maria Bernis on 03/12/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

// Constants
#define API_BASE_URL     @"https://redbooth.com"
#define API_CLIENT       @"56b67669c4c3251ca5aa45f1509526ef8eddff006956de014daa8b035b24dbd8"
#define API_SECRET       @"6c97be47b73147bb7af8ff3f1ddeb04aeda1b1b62666744aa9b3622105c1301f"
#define API_CALLBACK_URL @"http://www.laurarocacodina.com/authcode.html"
#define APP_URL_SCHEME   @"mbredbooth"
#define APP_CALLBACK_URI @"mbredbooth://authorise"

#define KEY_ACCESS_TOKEN  @"access_token"
#define KEY_TOKEN_EXPIRES @"access_token_expires"
#define KEY_REFRESH_TOKEN @"refresh_token"

@interface RedboothAPIClient : AFHTTPSessionManager

// Singleton instance
+ (RedboothAPIClient *)sharedInstance;

// Authentication
- (void)authorize;
- (void)authorisedWithCallback:(NSString *)urlParams;
- (void)setAuthorizationHeaderWithToken:(NSString *)token;
- (void)storeToken:(NSString *)token;
- (BOOL)hasStoredToken;

@end
