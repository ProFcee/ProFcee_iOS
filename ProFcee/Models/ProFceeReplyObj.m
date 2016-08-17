//
//  ProFceeReplyObj.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/5/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeReplyObj.h"

@implementation ProFceeReplyObj

- (id)init {
    self = [super init];
    if(self) {
        self.reply_id = @0;
        self.reply_conversation_id = @0;
        self.reply_body = @"";
        self.reply_user_id = @0;
        self.reply_is_read = NO;
        self.reply_created = [NSDate date];
        
        self.senderId = @"";
        self.senderDisplayName = [GlobalService sharedInstance].user_me.my_user.user_name;
        self.isMediaMessage = NO;
        self.text = @"";
        self.date = [NSDate date];
    }
    
    return self;
}

- (ProFceeReplyObj *)initWithDictionary:(NSDictionary *)dicReply {
    ProFceeReplyObj *objReply = [[ProFceeReplyObj alloc] init];
    
    if(dicReply[@"id"] && ![dicReply[@"id"] isEqual:[NSNull null]]) {
        objReply.reply_id = [NSNumber numberWithInt:[dicReply[@"id"] intValue]];
    }
    
    if(dicReply[@"conversation_id"] && ![dicReply[@"conversation_id"] isEqual:[NSNull null]]) {
        objReply.reply_conversation_id = [NSNumber numberWithInt:[dicReply[@"conversation_id"] intValue]];
    }
    
    if(dicReply[@"body"] && ![dicReply[@"body"] isEqual:[NSNull null]]) {
        objReply.reply_body = dicReply[@"body"];
    }
    
    if(dicReply[@"user_id"] && ![dicReply[@"user_id"] isEqual:[NSNull null]]) {
        objReply.reply_user_id = [NSNumber numberWithInt:[dicReply[@"user_id"] intValue]];
    }
    
    if(dicReply[@"is_read"] && ![dicReply[@"is_read"] isEqual:[NSNull null]]) {
        objReply.reply_is_read = [dicReply[@"is_read"] boolValue];
    }
    
    if(dicReply[@"created"] && ![dicReply[@"created"] isEqual:[NSNull null]]) {
        objReply.reply_created = [[GlobalService sharedInstance] dateFromString:dicReply[@"created"] withFormat:nil];
    }
    
    objReply.senderId = objReply.reply_user_id.stringValue;
    objReply.text = objReply.reply_body;
    objReply.date = objReply.reply_created;
    
    return objReply;
}

- (ProFceeReplyObj *)initWithConversationId:(NSNumber *)conversation_id
                                    Message:(NSString *)message
                                     UserId:(NSNumber *)user_id {
    ProFceeReplyObj *objReply = [[ProFceeReplyObj alloc] init];
    
    objReply.reply_conversation_id = conversation_id;
    objReply.reply_body = message;
    objReply.reply_user_id = user_id;
        
    objReply.senderId = objReply.reply_user_id.stringValue;
    objReply.text = objReply.reply_body;
    objReply.date = objReply.reply_created;
    
    return objReply;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"conversation_id":    self.reply_conversation_id,
             @"body":               self.reply_body,
             @"user_id":            self.reply_user_id,
             @"is_read":            [NSNumber numberWithBool:self.reply_is_read],
             @"created":            [[GlobalService sharedInstance] stringFromDate:self.reply_created withFormat:nil]
             };
}

- (NSUInteger)messageHash
{
    return self.hash;
}

- (NSUInteger)hash
{
    NSUInteger contentHash = self.isMediaMessage ? [self.media mediaHash] : self.text.hash;
    return self.senderId.hash ^ self.date.hash ^ contentHash;
}

@end
