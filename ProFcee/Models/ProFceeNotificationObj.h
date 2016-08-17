//
//  ProFceeNotificationObj.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PROFCEE_PUSH_TYPE_AGREE_TREND = 0,
    PROFCEE_PUSH_TYPE_SHARE_TREND,
    PROFCEE_PUSH_TYPE_REPORT_TREND,
    PROFCEE_PUSH_TYPE_SEND_MESSAGE,
    PROFCEE_PUSH_TYPE_BLOCK_USER
}PROFCEE_PUSH_TYPE;

@interface ProFceeNotificationObj : NSObject

@property (nonatomic, retain) NSNumber              *notification_id;
@property (nonatomic, retain) ProFceeUserObj        *notification_user;
@property (nonatomic, retain) NSNumber              *notification_object_id;
@property (nonatomic, retain) NSString              *notification_text;
@property (nonatomic, readwrite) PROFCEE_PUSH_TYPE  notification_type;
@property (nonatomic, readwrite) BOOL               notification_is_read;
@property (nonatomic, retain) NSDate                *notification_created;

- (ProFceeNotificationObj *)initWithDictionary:(NSDictionary *)dicNotification;
- (NSDictionary *)currentDictionary;

@end
