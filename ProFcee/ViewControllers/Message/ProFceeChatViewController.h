//
//  ProFceeChatViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/5/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DXPopover/DXPopover.h>

@interface ProFceeChatViewController : UIViewController {
    DXPopover           *m_viewPopover;
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgUser2Avatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblUser2Name;
@property (strong, nonatomic) IBOutlet UIButton *m_btnBlock;
@property (weak, nonatomic) IBOutlet UIView *m_viewChat;
@property (weak, nonatomic) IBOutlet UIView *m_viewParallaxHeader;

@property (nonatomic, retain) ProFceeChatRoomObj        *m_objChatRoom;

- (IBAction)onClickBtnMenu:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnBlock:(id)sender;

@end
