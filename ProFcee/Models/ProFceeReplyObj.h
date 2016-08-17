//
//  ProFceeReplyObj.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/5/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSQMessagesViewController/JSQMessages.h>

@interface ProFceeReplyObj : NSObject<JSQMessageData>

@property (nonatomic, retain) NSNumber          *reply_id;
@property (nonatomic, retain) NSNumber          *reply_conversation_id;
@property (nonatomic, retain) NSString          *reply_body;
@property (nonatomic, retain) NSNumber          *reply_user_id;
@property (nonatomic, readwrite) BOOL           reply_is_read;
@property (nonatomic, retain) NSDate            *reply_created;

//JSQMessage Variables
@property (nonatomic, retain) NSString          *senderId;
@property (nonatomic, retain) NSString          *senderDisplayName;
@property (nonatomic, readwrite) BOOL           isMediaMessage;
@property (nonatomic, retain) NSString          *text;
@property (nonatomic, retain) NSDate            *date;

- (ProFceeReplyObj *)initWithDictionary:(NSDictionary *)dicReply;
- (ProFceeReplyObj *)initWithConversationId:(NSNumber *)conversation_id
                                    Message:(NSString *)message
                                     UserId:(NSNumber *)user_id;
- (NSDictionary *)currentDictionary;

@end
