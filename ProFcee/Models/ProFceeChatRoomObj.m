//
//  ProFceeChatRoomObj.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/5/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeChatRoomObj.h"

@implementation ProFceeChatRoomObj

- (id)init {
    self = [super init];
    if(self) {
        self.conversation_id = @0;
        self.conversation_new = @0;
        self.conversation_agreed = NO;
        self.conversation_user = [[ProFceeUserInfoObj alloc] init];
        self.conversation_trend = [[ProFceeTrendObj alloc] init];
    }
    
    return self;
}

- (ProFceeChatRoomObj *)initWithDictionary:(NSDictionary *)dicChatRoom {
    ProFceeChatRoomObj *objChatRoom = [[ProFceeChatRoomObj alloc] init];
    
    if(dicChatRoom[@"conversation_id"] && ![dicChatRoom[@"conversation_id"] isEqual:[NSNull null]]) {
        objChatRoom.conversation_id = [NSNumber numberWithInt:[dicChatRoom[@"conversation_id"] intValue]];
    }
    
    if(dicChatRoom[@"conversation_new"] && ![dicChatRoom[@"conversation_new"] isEqual:[NSNull null]]) {
        objChatRoom.conversation_new = [NSNumber numberWithInt:[dicChatRoom[@"conversation_new"] intValue]];
    }
    
    if(dicChatRoom[@"conversation_agreed"] && ![dicChatRoom[@"conversation_agreed"] isEqual:[NSNull null]]) {
        objChatRoom.conversation_agreed = [dicChatRoom[@"conversation_agreed"] boolValue];
    }
    
    if(dicChatRoom[@"User"] && ![dicChatRoom[@"User"] isEqual:[NSNull null]]) {
        objChatRoom.conversation_user = [[ProFceeUserInfoObj alloc] initWithDictionary:dicChatRoom[@"User"]];
    }
    
    if(dicChatRoom[@"Trend"] && ![dicChatRoom[@"Trend"] isEqual:[NSNull null]]) {
        objChatRoom.conversation_trend = [[ProFceeTrendObj alloc] initWithDictionary:dicChatRoom[@"Trend"]];
    }
    
    return objChatRoom;
}

@end
