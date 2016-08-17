//
//  GlobalService.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 4/10/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ProFceeNormalTabBarController.h"
#import "ProFceeUserTabBarController.h"
#import "ProFceeUserMe.h"

@interface GlobalService : NSObject

@property (nonatomic, readwrite) BOOL                           is_internet_alive;
@property (nonatomic, retain) ProFceeNormalTabBarController     *normal_tabbar;
@property (nonatomic, retain) ProFceeUserTabBarController       *user_tabbar;
@property (nonatomic, retain) NSString                          *device_token;
@property (nonatomic, retain) ProFceeUserMe                     *user_me;
@property (nonatomic, retain) NSMutableArray                    *search_history;
@property (nonatomic, retain) AppDelegate                       *app_delegate;

@property (nonatomic, retain) ProFceeCityObj                    *user_city;
@property (nonatomic, retain) NSArray                           *user_countries;
@property (nonatomic, retain) NSArray                           *user_states;
@property (nonatomic, retain) NSArray                           *user_cities;

+ (GlobalService *) sharedInstance;

- (ProFceeUserMe *)loadMe;
- (void)saveMe;
- (void)removeMe;

- (NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)dateFormat;
- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;

- (ProFceeCountryObj *)getCountryWithName:(NSString *)country_name;
- (ProFceeStateObj *)getStateWithName:(NSString *)state_name;
- (ProFceeCityObj *)getCityWithName:(NSString *)city_name;

- (void)addSearchHistory:(NSString *)search;

@end
