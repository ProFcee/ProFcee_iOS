//
//  WebService.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 4/10/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProFceeUserMe.h"
#import "ProFceeTrendInfoObj.h"
#import "ProFceeUserInfoObj.h"
#import "ProFceeNotificationObj.h"
#import "ProFceeSettingsObj.h"
#import "ProFceeChatRoomObj.h"
#import "ProFceeReplyObj.h"

typedef enum {
    TREND_NORMAL = 0,
    TREND_NORMAL_TOP_RATED,
    TREND_PICK,
    TREND_USER_TOP_RATED
}TREND_TYPE;

typedef enum {
    SEARCH_USER_BY_NAME = 0,
    SEARCH_USER_BY_EMAIL,
    SEARCH_TREND_BY_KEYWORD,
    SEARCH_TREND_BY_REGION,
}SEARCH_TYPE;

@interface WebService : NSObject

@property (nonatomic, retain) NSString    *m_strProfceeDomain;

+ (WebService *) sharedInstance;

#pragma mark - User
- (void)signUpUserWithEmail:(NSString *)email
                   UserName:(NSString *)name
                   Password:(NSString *)password
                  Completed:(void (^)(ProFceeUserMe *, NSString *))completed;
- (void)loginUserWithEmail:(NSString *)email
                  Password:(NSString *)password
                 Completed:(void (^)(ProFceeUserMe *, NSString *))completed;
- (void)forgotPasswordWithEmail:(NSString *)email
                      Completed:(void (^)(NSString *, NSString *))completed;
- (void)resetPasswordWithCode:(NSString *)code
                  NewPassword:(NSString *)password
                    Completed:(void (^)(NSString *, NSString *))completed;
- (void)updatePasswordWithCurrentPassword:(NSString *)current_pass
                              NewPassword:(NSString *)new_pass
                                Completed:(void (^)(NSString *, NSString *))completed;
- (void)socialLoginWithEmail:(NSString *)email
                        Name:(NSString *)name
                    Password:(NSString *)password
                ProfileImage:(NSString *)avatar_url
                   Completed:(void (^)(ProFceeUserMe *, NSString *))completed;
- (void)logoutUserWithId:(NSNumber *)user_id
               Completed:(void (^)(NSString *, NSString *))completed;
- (void)updateUserWithUserObj:(ProFceeUserObj *)objUser
                 ProfileImage:(UIImage *)imgAvatar
                  BannerImage:(UIImage *)imgBanner
                     Progress:(void (^)(double))progress
                    Completed:(void (^)(ProFceeUserObj *, NSString *))completed;
- (void)deactivateUser:(void (^)(NSString *, NSString *))completed;
- (void)getUserTrends:(NSNumber *)user_id
            Completed:(void (^)(NSArray *, NSString *))completed;
- (void)getUserAgreedTrends:(NSNumber *)user_id
                  Completed:(void (^)(NSArray *, NSString *))completed;

#pragma mark - Location
- (void)getCountries:(void (^)(NSArray *, NSString *))completed;
- (void)getStatesWithCountryId:(NSNumber *)country_id Completed:(void (^)(NSArray *, NSString *))completed;
- (void)getCitiesWithStateId:(NSNumber *)state_id Completed:(void (^)(NSArray *, NSString *))completed;

#pragma mark - Trend
- (void)createNewTrend:(NSString *)trend_body
                 Image:(UIImage *)trend_image
              Progress:(void (^)(double))progress
             Completed:(void (^)(NSString *, NSString *))completed;
- (void)getTrendByType:(TREND_TYPE)type
             Completed:(void (^)(NSArray *, NSString *))completed;
- (void)agreeTrend:(NSNumber *)trend_id
         Completed:(void (^)(NSString *, NSString *))completed;
- (void)shareTrend:(NSNumber *)trend_id
         Completed:(void (^)(NSString *, NSString *))completed;
- (void)reportTrend:(NSNumber *)trend_id
          Completed:(void (^)(NSString *, NSString *))completed;
- (void)getTrendAgrees:(NSNumber *)trend_id
             Completed:(void (^)(NSArray *, NSString *))completed;
- (void)deleteTrend:(NSNumber *)trend_id
          Completed:(void (^)(NSString *, NSString *))completed;

#pragma mark - Notification
- (void)getUserNotifications:(void (^)(NSArray *, NSString *))completed;
- (void)markNotificationsAsRead:(void (^)(NSString *, NSString *))completed;
- (void)clearUserNotifications:(void (^)(NSString *, NSString *))completed;
- (void)getNotificationWithId:(NSNumber *)notification_id
                    Completed:(void (^)(ProFceeNotificationObj *, NSString *))completed;
- (void)removeNotificationWithId:(NSNumber *)notification_id
                       Completed:(void (^)(NSString *, NSString *))completed;

#pragma mark - Settings
- (void)getUserSettings:(void (^)(ProFceeSettingsObj *, NSString *))completed;
- (void)updateUserSettings:(ProFceeSettingsObj *)objSettings
                 Completed:(void (^)(NSString *, NSString *))completed;

#pragma mark - Message
- (void)createChatRoom:(NSArray *)user_ids
               TrendId:(NSNumber *)trend_id
               Message:(NSString *)message
             Completed:(void (^)(NSString *, NSString *))completed;
- (void)getChatrooms:(void (^)(NSArray *, NSString *))completed;
- (void)getAllRepliesWithConversationId:(NSNumber *)conversation_id
                              Completed:(void (^)(NSArray *, NSString *))completed;
- (void)deleteConversation:(NSNumber *)conversation_id
                 Completed:(void (^)(NSString *, NSString *))completed;
- (void)blockChatroomWithConversationId:(NSNumber *)conversation_id
                               UserName:(NSString *)user_name
                              Completed:(void (^)(NSString *, NSString *))completed;
- (void)sendReplyWithConversationId:(NSNumber *)conversation_id
                            Message:(NSString *)message
                           UserName:(NSString *)user_name
                          Completed:(void (^)(NSString *, NSString *))completed;
- (void)getReplyById:(NSNumber *)reply_id
           Completed:(void (^)(ProFceeReplyObj *, NSString *))completed;
- (void)deleteReply:(NSNumber *)reply_id
          Completed:(void (^)(NSString *, NSString *))completed;
- (void)markReplyAsRead:(NSNumber *)reply_id
              Completed:(void (^)(NSString *, NSString *))completed;
#pragma mark - Search
- (void)searchKeyword:(NSString *)keyword
             WithKind:(SEARCH_TYPE)type
            Completed:(void (^)(NSArray *, NSString *))completed;

@end
