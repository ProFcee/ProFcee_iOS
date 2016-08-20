//
//  Constants.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define IP_FETCH_DOMAIN_ADDRESS                 @"http://profcee.net/response_profcee.json"

#define HTTP_HEADER_ACCESS_TOKEN                @"AccessToken"
#define SERVER_RESPONSE_MESSAGE                 @"message"
#define SERVER_RESPONSE_UNAUTHENTICATE_CODE     401

#define APP_NAME                                @"ProFcee"

//Normal TabBar Index
#define NORMAL_SIGNUP_TABBAR_INDEX              0
#define NORMAL_HOME_TABBAR_INDEX                1
#define NORMAL_PROPHECY_TABBAR_INDEX            2
#define NORMAL_LOGIN_TABBAR_INDEX               3

//User TabBar Index
#define USER_HOME_TABBAR_INDEX                  0
#define USER_PROPHECY_TABBAR_INDEX              1
#define USER_POST_TABBAR_INDEX                  2
#define USER_MESSAGE_TABBAR_INDEX               3
#define USER_ME_TABBAR_INDEX                    4

//SVProgressHUD
#define SVPROGRESSHUD_PLEASE_WAIT               [SVProgressHUD showWithStatus:@"Please wait..."]
#define SVPROGRESSHUD_DISMISS                   [SVProgressHUD dismiss]
#define SVPROGRESSHUD_SUCCESS(status)           [SVProgressHUD showSuccessWithStatus:status]
#define SVPROGRESSHUD_ERROR(status)             [SVProgressHUD showErrorWithStatus:status]
#define SVPROGRESSHUD_PROGRESS(progress)        [SVProgressHUD showProgress:progress status:@"Uploading..."];

//String Constants
#define STRING_NO_INTERNET                      @"No Internet Connection!"

//Urls
#define PROFCEE_TERMS_URL                       @"http://www.profcee.com/terms-of-services.html"
#define PROFCEE_PRIVACY_URL                     @"http://www.profcee.com/privacy-policy.html"

//PopoverView Tags
#define POPOVER_ITEM_SETTINGS                   10
#define POPOVER_ITEM_ABOUTUS                    11
#define POPOVER_ITEM_TERMS                      12
#define POPOVER_ITEM_PRIVACY                    13

//Toast Strings
#define TOAST_MESSAGE_INVALID_EMAIL             @"Invalid email address"
#define TOAST_MESSAGE_NO_USERNAME               @"Please enter your name"
#define TOAST_MESSAGE_SHORT_PASSWORD            @"Password must be 6 or more characters"
#define TOAST_MESSAGE_TREND_OWNER               @"You can't agree or report your own Trends"
#define TOAST_MESSAGE_TREND_NOT_OWNER           @"You can view users who agree to your Trends only"
#define TOAST_MESSAGE_TREND_NO_AGREES           @"No one agreed to it yet. Share your Trend now!"
#define TOAST_MESSAGE_TREND_REPORT_PAST         @"You have already reported this Trend"
#define TOAST_MESSAGE_TREND_AGREE_PAST          @"You have already agreed to this Trend"
#define TOAST_MESSAGE_TREND_NO_BODY             @"Please enter the Trend"
#define TOAST_MESSAGE_NO_CODE                   @"Please enter confirmation code"
#define TOAST_MESSAGE_DISMATCH_PASSWORD         @"Password mismatch"
#define TOAST_MESSAGE_NO_MESSAGE                @"Please enter your message"

//UserDefaultsKeys
#define USER_DEFAULTS_KEY_ME                    @"UserDefaultsKeyMe"
#define USER_DEFAULTS_KEY_FIRST_USER            @"UserDefaultsKeyFirstUse"
#define USER_DEFAULTS_KEY_SEARCH_HISTORY        @"UserDefaultsKeySearchHistory"

//UserNotification
#define USER_NOTIFICATION_GOT_LOCATION          @"UserNotificationGotLocation"
#define USER_NOTIFICATION_GOT_NOTIFICATIONS     @"UserNotificationGotNotifications"
#define USER_NOTIFICATION_GOT_SETTINGS          @"UserNotificationGotSettings"
#define USER_NOTIFICATION_GOT_MESSAGE           @"UserNotificationGotMessage"
#define USER_NOTIFICATION_TOKEN_EXPIRED         @"UserNotificationTokenExpired"
#define USER_NOTIFICATION_SHOW_TREND            @"UserNotificationShowTrend"
#define USER_NOTIFICATION_SHOW_MESSAGE          @"UserNotificationShowMessage"
#define USER_NOTIFICATION_CREATE_CHATROOM       @"UserNotificationCreateChatroom"

//AssetsName
#define ASSETS_AVATAR_PLACEHOLDER               @"image_avatar_placeholder"
#define ASSETS_BANNER_PLACEHOLDER               @"login_image_banner_placeholder"

#define TREND_IMAGE_RATIO                       9.f / 16.f

#define IS_IPHONE                               (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#endif /* Constants_h */
