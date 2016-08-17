//
//  ProFceeSubChatViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/6/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHParallaxViewController.h"

@interface ProFceeSubChatViewController : JHParallaxViewController {
    JSQMessagesBubbleImage      *outgoingBubbleImageData;
    JSQMessagesBubbleImage      *incomingBubbleImageData;
    
    JSQMessagesAvatarImage      *incomingAvatarImage;
    
    NSMutableArray              *m_aryMessages;
}

@property (nonatomic, retain) ProFceeChatRoomObj        *m_objChatRoom;
@property (nonatomic, retain) UIImage                   *m_imgUser2Avatar;

@end
