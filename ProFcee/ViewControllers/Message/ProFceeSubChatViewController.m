//
//  ProFceeSubChatViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/6/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeSubChatViewController.h"
#import "ProFceeTrendCollectionReusableView.h"
#import "ProFceeChatViewController.h"

@interface ProFceeSubChatViewController ()

@end

@implementation ProFceeSubChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] getAllRepliesWithConversationId:self.m_objChatRoom.conversation_id
                                                       Completed:^(NSArray *aryReplies, NSString *strError) {
                                                           if(!strError) {
                                                               SVPROGRESSHUD_DISMISS;
                                                               m_aryMessages = [NSMutableArray arrayWithArray:aryReplies];
                                                               [self finishReceivingMessage];
                                                           } else {
                                                               SVPROGRESSHUD_ERROR(strError);
                                                           }
                                                       }];
    
    //config JSMessageViewController
    self.senderId = [GlobalService sharedInstance].user_me.my_user.user_id.stringValue;
    self.senderDisplayName = [GlobalService sharedInstance].user_me.my_user.user_name;
    
    self.inputToolbar.contentView.leftBarButtonItemWidth = 0.f;
    
    incomingAvatarImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:self.m_imgUser2Avatar
                                                                     diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(38.f, 38.f);
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    self.collectionView.backgroundColor = UIColor.clearColor;
    self.view.backgroundColor = UIColor.clearColor;
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor hx_colorWithHexRGBAString:@"#F5DCDD"]];
    incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor whiteColor]];
    
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    
    [self.inputToolbar.contentView.rightBarButtonItem setTitle:@"" forState:UIControlStateNormal];
    [self.inputToolbar.contentView.rightBarButtonItem setImage:[UIImage imageNamed:@"message_button_send"]
                                                      forState:UIControlStateNormal];
    self.inputToolbar.contentView.rightBarButtonItemWidth = 32.f;
    self.inputToolbar.contentView.textView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.05f];
    self.inputToolbar.contentView.textView.placeHolder = @"Type your message here";
    
    if([GlobalService sharedInstance].user_me.my_settings.settings_suggest_typing){
        [self.inputToolbar.contentView.textView setAutocorrectionType:UITextAutocorrectionTypeYes];
    } else {
        [self.inputToolbar.contentView.textView setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    
    if([GlobalService sharedInstance].user_me.my_settings.settings_spell_typing){
        [self.inputToolbar.contentView.textView setSpellCheckingType:UITextSpellCheckingTypeYes];
    } else {
        [self.inputToolbar.contentView.textView setSpellCheckingType:UITextSpellCheckingTypeNo];
    }
    
    self.m_viewScroll = self.collectionView;
    
    //header view
    [self.collectionView registerNib:[ProFceeTrendCollectionReusableView nib]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:[ProFceeTrendCollectionReusableView headerReuseIdentifier]];
    
    self.automaticallyScrollsToMostRecentMessage = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGotNewMessage:)
                                                 name:USER_NOTIFICATION_GOT_MESSAGE
                                               object:self.m_objChatRoom.conversation_id];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)onGotNewMessage:(NSNotification *)notification {
    ProFceeReplyObj *objReply = [[ProFceeReplyObj alloc] initWithDictionary:notification.userInfo];
    [m_aryMessages addObject:objReply];
    
    [self finishSendingMessageAnimated:YES];
    [self scrollToBottomAnimated:YES];
    
    [[WebService sharedInstance] markReplyAsRead:objReply.reply_id
                                       Completed:^(NSString *strResult, NSString *strError) {
                                           if(!strError) {
                                               NSLog(@"%@", strResult);
                                           } else {
                                               NSLog(@"%@", strError);
                                           }
                                       }];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [m_aryMessages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeReplyObj *objReply = m_aryMessages[indexPath.item];
    
    [m_aryMessages removeObjectAtIndex:indexPath.item];
    [[WebService sharedInstance] deleteReply:objReply.reply_id
                                   Completed:^(NSString *strResult, NSString *strError) {
                                       if(!strError) {
                                           NSLog(@"%@", strResult);
                                       } else {
                                           NSLog(@"%@", strError);
                                       }
                                   }];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeReplyObj *message = [m_aryMessages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return outgoingBubbleImageData;
    }
    
    return incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeReplyObj *message = [m_aryMessages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    } else {
        return incomingAvatarImage;
    }
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeReplyObj *message = [m_aryMessages objectAtIndex:indexPath.item];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"h:mm a";
    
    NSAttributedString *strDate = [[NSAttributedString alloc] initWithString:[formatter stringFromDate:message.date]
                                                                  attributes:@{
                                                                               NSForegroundColorAttributeName: [UIColor hx_colorWithHexRGBAString:@"#B8B8B8"],
                                                                               NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:11.f]
                                                                               }];
    return strDate;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UICollectionReusableView *)collectionView:(JSQMessagesCollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ProFceeTrendCollectionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                                 withReuseIdentifier:[ProFceeTrendCollectionReusableView headerReuseIdentifier]
                                                                                                        forIndexPath:indexPath];
        headerView.m_lblTrendBody.text = self.m_objChatRoom.conversation_trend.trend_body;
        
        CGFloat fTrendImageHeight = 0;
        if(self.m_objChatRoom.conversation_trend.trend_image.length > 0) {
            [headerView.m_imgTrend setImageWithUrl:self.m_objChatRoom.conversation_trend.trendUrl withPlaceholder:nil];
            fTrendImageHeight = (CGRectGetWidth(self.view.frame) - 20) * TREND_IMAGE_RATIO;
        }
        headerView.m_constraintImageHeight.constant = fTrendImageHeight;
        
        return headerView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat fTrendImageHeight = 0;
    if(self.m_objChatRoom.conversation_trend.trend_image.length > 0) {
        fTrendImageHeight = (CGRectGetWidth(self.view.frame) - 20) * TREND_IMAGE_RATIO;
    }
    
    CGFloat fBodyHeight = [self labelHeightForText:[[NSAttributedString alloc] initWithString:self.m_objChatRoom.conversation_trend.trend_body
                                                                                   attributes:@{
                                                                                                NSFontAttributeName: IS_IPHONE ?
                                                                                                [UIFont fontWithName:@".SFUIText-Regular" size:14.f] :
                                                                                                [UIFont fontWithName:@".SFUIText-Regular" size:19.f]
                                                                                                }]];
    
    return CGSizeMake([collectionViewLayout itemWidth], fTrendImageHeight + fBodyHeight + 46.f);
}

- (CGFloat)labelHeightForText:(NSAttributedString *)txt
{
    CGFloat maxWidth = CGRectGetWidth(self.view.frame) - 40.f;
    CGFloat maxHeight = 1000;
    
    CGSize stringSize;
    
    CGRect stringRect = [txt boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          context:nil];
    
    stringSize = CGRectIntegral(stringRect).size;
    
    return roundf(stringSize.height);
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return m_aryMessages.count;
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    ProFceeReplyObj *message = [m_aryMessages objectAtIndex:indexPath.item];
    
    if (!message.isMediaMessage) {
        
        cell.textView.textColor = [UIColor blackColor];
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

- (BOOL)shouldShowAccessoryButtonForMessage:(id<JSQMessageData>)message
{
    return NO;
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    ProFceeReplyObj *message = [m_aryMessages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    ProFceeReplyObj *objReply = [[ProFceeReplyObj alloc] initWithConversationId:self.m_objChatRoom.conversation_id
                                                                        Message:text
                                                                         UserId:[NSNumber numberWithInt:senderId.intValue]];
    
    [m_aryMessages addObject:objReply];
    [self finishSendingMessageAnimated:YES];
    [self scrollToBottomAnimated:YES];
    
    [[WebService sharedInstance] sendReplyWithConversationId:self.m_objChatRoom.conversation_id
                                                     Message:text
                                                    UserName:senderDisplayName
                                                   Completed:^(NSString *strResult, NSString *strError) {
                                                       if(!strError) {
                                                           NSLog(@"%@", strResult);
                                                       } else {
                                                           NSLog(@"%@", strError);
                                                       }
                                                   }];
}

@end
