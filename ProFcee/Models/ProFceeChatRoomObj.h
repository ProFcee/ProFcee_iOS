//
//  ProFceeChatRoomObj.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/5/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProFceeUserInfoObj.h"

@interface ProFceeChatRoomObj : NSObject

@property (nonatomic, retain) NSNumber              *conversation_id;
@property (nonatomic, retain) NSNumber              *conversation_new;
@property (nonatomic, readwrite) BOOL               conversation_agreed;
@property (nonatomic, retain) ProFceeUserInfoObj    *conversation_user;
@property (nonatomic, retain) ProFceeTrendObj       *conversation_trend;

- (ProFceeChatRoomObj *)initWithDictionary:(NSDictionary *)dicChatRoom;

@end
