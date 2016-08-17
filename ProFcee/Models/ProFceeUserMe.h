//
//  ProFceeUserMe.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/28/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProFceeLocationObj.h"
#import "ProFceeUserObj.h"
#import "ProFceeSettingsObj.h"

@interface ProFceeUserMe : NSObject

@property (nonatomic, retain) ProFceeCityObj            *my_city;
@property (nonatomic, retain) ProFceeUserObj            *my_user;
@property (nonatomic, retain) NSString                  *my_access_token;
@property (nonatomic, retain) NSMutableArray            *my_notifications;
@property (nonatomic, retain) ProFceeSettingsObj        *my_settings;

- (ProFceeUserMe *)initWithDictionary:(NSDictionary *)dicUserMe;
- (NSDictionary *)currentDictionary;

#pragma mark - Custom Functions
- (NSInteger)getNewNotificationCount;
- (void)markNotificationsAsRead;
- (void)removeAllNotifications;
- (void)removeNotificationWithId:(NSNumber *)notificaiton_id;

@end
