//
//  AppDelegate.m
//  Profcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //SVProgressHUD config
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#640009"]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setFont:IS_IPHONE ? [UIFont fontWithName:@".SFUIText-Regular" size:15.f] : [UIFont fontWithName:@".SFUIText-Regular" size:20.f]];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    
    //Fabric config
    [Fabric with:@[[Crashlytics class], [Twitter class]]];
    
    //Keyboard config
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    
    //Toast config
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#640009"];
    style.titleColor = [UIColor whiteColor];
    style.messageColor = [UIColor whiteColor];
    style.titleFont = IS_IPHONE ? [UIFont fontWithName:@".SFUIText-Bold" size:16.f] : [UIFont fontWithName:@".SFUIText-Bold" size:21.f];
    style.messageFont = IS_IPHONE ? [UIFont fontWithName:@".SFUIText-Regular" size:15.f] : [UIFont fontWithName:@".SFUIText-Regular" size:20.f];
    [CSToastManager setSharedStyle:style];
    
    //PushNotification config
#if IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_8_0
    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge
                                                                            | UIRemoteNotificationTypeSound
                                                                            | UIRemoteNotificationTypeAlert)];
#endif
    
    [self checkReachability];
    
    [GlobalService sharedInstance].app_delegate = self;
    ProFceeUserMe *userMe = [[GlobalService sharedInstance] loadMe];
    if(userMe) {
        [GlobalService sharedInstance].user_me = userMe;
        [self startApplication];
    }
    
    [self startGetLocation];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)startGetLocation {
    m_locationManager = [[CLLocationManager alloc] init];
    
    [m_locationManager requestWhenInUseAuthorization];
    m_locationManager.distanceFilter = kCLDistanceFilterNone;
    m_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    m_locationManager.delegate = self;
    
    [m_locationManager startUpdatingLocation];
}

#pragma mark - CLLocationDelegate
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            
            NSLog(@"%@, %@, %@", placemark.locality, placemark.administrativeArea, placemark.country);
            [m_locationManager stopUpdatingLocation];
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self getUserLocationInformationWithPlacemark:placemark];
            });
        }
    }];
}

- (void)getUserLocationInformationWithPlacemark:(CLPlacemark *)placemark {
    [[WebService sharedInstance] getCountries:^(NSArray *aryCountries, NSString *strError) {
        if(!strError) {
            [GlobalService sharedInstance].user_countries = aryCountries;
            ProFceeCountryObj *objCountry = [[GlobalService sharedInstance] getCountryWithName:placemark.country];
            [[WebService sharedInstance] getStatesWithCountryId:objCountry.country_id Completed:^(NSArray *aryStates, NSString *strError) {
                if(!strError) {
                    [GlobalService sharedInstance].user_states = aryStates;
                    ProFceeStateObj *objState = [[GlobalService sharedInstance] getStateWithName:placemark.administrativeArea];
                    objState.state_country = objCountry;
                    [[WebService sharedInstance] getCitiesWithStateId:objState.state_id Completed:^(NSArray *aryCities, NSString *strError) {
                        if(!strError) {
                            [GlobalService sharedInstance].user_cities = aryCities;
                            ProFceeCityObj *objCity = [[GlobalService sharedInstance] getCityWithName:placemark.locality];
                            objCity.city_state = objState;
                            [GlobalService sharedInstance].user_city = objCity;
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_GOT_LOCATION object:nil];
                        } else {
                            NSLog(@"%@", strError);
                        }
                    }];
                } else {
                    NSLog(@"%@", strError);
                }
            }];
            
        } else {
            NSLog(@"%@", strError);
        }
    }];
}

- (void)startApplication {
    [self getUserNotifications];
    [self getUserSettings];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    UIViewController *user_tabbar = [storyboard instantiateViewControllerWithIdentifier:@"ProFceeUserTabBarController"];
    [navController pushViewController:user_tabbar animated:NO];
}

- (void)getUserNotifications {
    [[WebService sharedInstance] getUserNotifications:^(NSArray *aryNotifications, NSString *strError) {
        if(!strError) {
            NSLog(@"Got User Notifications");
            
            [[GlobalService sharedInstance].user_me.my_notifications setArray:aryNotifications];
            [[GlobalService sharedInstance] saveMe];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_GOT_NOTIFICATIONS object:nil];
        } else {
            NSLog(@"%@", strError);
        }
    }];
}

- (void)getUserSettings {
    [[WebService sharedInstance] getUserSettings:^(ProFceeSettingsObj *objUserSettings, NSString *strError) {
        if(!strError) {
            NSLog(@"Got User Settings");
            
            [GlobalService sharedInstance].user_me.my_settings = objUserSettings;
            [[GlobalService sharedInstance] saveMe];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_GOT_SETTINGS object:nil];
        } else {
            NSLog(@"%@", strError);
        }
    }];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* strDeviceToken = [[[[deviceToken description]
                                  stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                 stringByReplacingOccurrencesOfString: @">" withString: @""]
                                stringByReplacingOccurrencesOfString: @" " withString: @""];
    [GlobalService sharedInstance].device_token = strDeviceToken;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if(userInfo[@"aps"][@"noti_id"] && ![userInfo[@"aps"][@"noti_id"] isEqual:[NSNull null]]) {
        [[WebService sharedInstance] getNotificationWithId:userInfo[@"aps"][@"noti_id"]
                                                 Completed:^(ProFceeNotificationObj *objNotification, NSString *strError) {
                                                     if(!strError) {
                                                         [self actionWithNotification:objNotification];
                                                         
                                                         [[GlobalService sharedInstance].user_me.my_notifications insertObject:objNotification
                                                                                                                       atIndex:0];
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_GOT_NOTIFICATIONS object:nil];
                                                     } else {
                                                         NSLog(@"%@", strError);
                                                     }
                                                 }];
    }
}

- (void)actionWithNotification:(ProFceeNotificationObj *)objNotification {
    switch (objNotification.notification_type) {
        case PROFCEE_PUSH_TYPE_SEND_MESSAGE: {
            [[WebService sharedInstance] getReplyById:objNotification.notification_object_id
                                            Completed:^(ProFceeReplyObj *objReply, NSString *strError) {
                                                if(!strError) {
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_GOT_MESSAGE
                                                                                                        object:objReply.reply_conversation_id
                                                                                                      userInfo:objReply.currentDictionary];
                                                } else {
                                                    NSLog(@"%@", strError);
                                                }
                                            }];
            break;
        }
        case PROFCEE_PUSH_TYPE_BLOCK_USER: {
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_GOT_MESSAGE
                                                                object:nil];
            
            break;
        }
        default:
            break;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
    if([GlobalService sharedInstance].user_me) {
        [self getUserNotifications];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if([[FBSDKApplicationDelegate sharedInstance] application:application
                                                      openURL:url
                                            sourceApplication:sourceApplication
                                                   annotation:annotation]) {
        return YES;
    } else if([[GIDSignIn sharedInstance] handleURL:url
                                  sourceApplication:sourceApplication
                                         annotation:annotation]) {
        return YES;
    } else if([[Twitter sharedInstance] application:application
                                            openURL:url
                                            options:@{}]) {
        return YES;
    }
    
    // Add any custom logic here.
    return NO;
}

- (void)checkReachability {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                [JDStatusBarNotification showWithStatus:STRING_NO_INTERNET
                                              styleName:JDStatusBarStyleError];
                [GlobalService sharedInstance].is_internet_alive = NO;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [JDStatusBarNotification dismissAnimated:YES];
                [GlobalService sharedInstance].is_internet_alive = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [JDStatusBarNotification dismissAnimated:YES];
                [GlobalService sharedInstance].is_internet_alive = YES;
                break;
                
            default:
                break;
        }
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

@end
