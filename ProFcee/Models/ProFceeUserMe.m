//
//  ProFceeUserMe.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/28/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeUserMe.h"

@implementation ProFceeUserMe

- (id)init {
    self = [super init];
    if(self) {
        self.my_city = [[ProFceeCityObj alloc] init];
        self.my_user = [[ProFceeUserObj alloc] init];
        self.my_access_token = @"";
        self.my_notifications = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (ProFceeUserMe *)initWithDictionary:(NSDictionary *)dicUserMe {
    ProFceeUserMe *objMe = [[ProFceeUserMe alloc] init];
    
    if(dicUserMe[@"City"] && ![dicUserMe[@"City"] isEqual:[NSNull null]]) {
        objMe.my_city = [[ProFceeCityObj alloc] initWithDictionary:dicUserMe[@"City"]];
    }
    
    if(dicUserMe[@"User"] && ![dicUserMe[@"User"] isEqual:[NSNull null]]) {
        objMe.my_user = [[ProFceeUserObj alloc] initWithDictionary:dicUserMe[@"User"]];
    }
    
    if(dicUserMe[@"access_token"] && ![dicUserMe[@"access_token"] isEqual:[NSNull null]]) {
        objMe.my_access_token = dicUserMe[@"access_token"];
    }
    
    if(dicUserMe[@"notifications"] && ![dicUserMe[@"notifications"] isEqual:[NSNull null]]) {
        for(NSDictionary *dicNotification in dicUserMe[@"notifications"]) {
            ProFceeNotificationObj *objTrendInfo = [[ProFceeNotificationObj alloc] initWithDictionary:dicNotification];
            [objMe.my_notifications addObject:objTrendInfo];
        }
    }
    
    return objMe;
}

- (NSDictionary *)currentDictionary {
    NSMutableArray *aryDicNotifications = [[NSMutableArray alloc] init];
    for(ProFceeNotificationObj *objNotification in self.my_notifications) {
        [aryDicNotifications addObject:objNotification.currentDictionary];
    }
    
    return @{
             @"City":           self.my_city.currentDictionary,
             @"User":           self.my_user.currentDictionary,
             @"access_token":   self.my_access_token,
             @"notifications":  aryDicNotifications
             };
}

#pragma mark - Custom Functions
- (NSInteger)getNewNotificationCount {
    NSInteger nNewNotificationCount = 0;
    for(ProFceeNotificationObj *objNotification in self.my_notifications) {
        if(!objNotification.notification_is_read) {
            nNewNotificationCount++;
        }
    }
    
    return nNewNotificationCount;
}

- (void)markNotificationsAsRead {
    for(ProFceeNotificationObj *objNotification in self.my_notifications) {
        objNotification.notification_is_read = YES;
    }
    
    [[GlobalService sharedInstance] saveMe];
}

- (void)removeAllNotifications {
    [self.my_notifications removeAllObjects];
    [[GlobalService sharedInstance] saveMe];
}

- (void)removeNotificationWithId:(NSNumber *)notificaiton_id {
    for(int nIndex = 0; nIndex < self.my_notifications.count; nIndex++) {
        ProFceeNotificationObj *objNotification = self.my_notifications[nIndex];
        if(objNotification.notification_id.intValue == notificaiton_id.intValue) {
            [self.my_notifications removeObjectAtIndex:nIndex];
            break;
        }
    }
    
    [[GlobalService sharedInstance] saveMe];
}

@end
