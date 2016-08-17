//
//  ProFceeNotificationObj.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeNotificationObj.h"

@implementation ProFceeNotificationObj

- (id)init {
    self = [super init];
    if(self) {
        self.notification_id = @0;
        self.notification_user = [[ProFceeUserObj alloc] init];
        self.notification_object_id = @0;
        self.notification_text = @"";
        self.notification_is_read = NO;
        self.notification_created = [NSDate date];
    }
    
    return self;
}

- (ProFceeNotificationObj *)initWithDictionary:(NSDictionary *)dicNotification {
    ProFceeNotificationObj *objNotification = [[ProFceeNotificationObj alloc] init];
    
    if(dicNotification[@"notification_id"] && ![dicNotification[@"notification_id"] isEqual:[NSNull null]]) {
        objNotification.notification_id = [NSNumber numberWithInt:[dicNotification[@"notification_id"] intValue]];
    }
    
    if(dicNotification[@"User"] && ![dicNotification[@"User"] isEqual:[NSNull null]]) {
        objNotification.notification_user = [[ProFceeUserObj alloc] initWithDictionary:dicNotification[@"User"]];
    }
    
    if(dicNotification[@"object_id"] && ![dicNotification[@"object_id"] isEqual:[NSNull null]]) {
        objNotification.notification_object_id = [NSNumber numberWithInt:[dicNotification[@"object_id"] intValue]];
    }
    
    if(dicNotification[@"notification_text"] && ![dicNotification[@"notification_text"] isEqual:[NSNull null]]) {
        objNotification.notification_text = dicNotification[@"notification_text"];
    }
    
    if(dicNotification[@"type"] && ![dicNotification[@"type"] isEqual:[NSNull null]]) {
        objNotification.notification_type = [dicNotification[@"type"] intValue];
    }
    
    if(dicNotification[@"is_read"] && ![dicNotification[@"email"] isEqual:[NSNull null]]) {
        objNotification.notification_is_read = [dicNotification[@"is_read"] boolValue];
    }
    
    if(dicNotification[@"created"] && ![dicNotification[@"created"] isEqual:[NSNull null]]) {
        objNotification.notification_created = [[GlobalService sharedInstance] dateFromString:dicNotification[@"created"] withFormat:nil];
    }
    
    return objNotification;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"notification_id":   self.notification_id,
             @"User":              self.notification_user.currentDictionary,
             @"object_id":         self.notification_object_id,
             @"notification_text": self.notification_text,
             @"is_read":           [NSNumber numberWithBool:self.notification_is_read],
             @"created":           [[GlobalService sharedInstance] stringFromDate:self.notification_created withFormat:nil]
             };
}

@end
