//
//  ProFceeChatViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/5/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeChatViewController.h"
#import "ProFceeSubChatViewController.h"

@interface ProFceeChatViewController ()

@end

@implementation ProFceeChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.m_imgUser2Avatar.layer.masksToBounds = YES;
    self.m_imgUser2Avatar.layer.cornerRadius = CGRectGetHeight(self.m_imgUser2Avatar.frame) / 2.f;
    [self.m_imgUser2Avatar setImageWithUrl:self.m_objChatRoom.conversation_user.user_info_user.avatarUrl
                           withPlaceholder:nil];
    
    self.m_lblUser2Name.text = self.m_objChatRoom.conversation_user.user_info_user.user_name.uppercaseString;
    
    ProFceeSubChatViewController *subChatVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProFceeSubChatViewController class])];
    subChatVC.m_objChatRoom = self.m_objChatRoom;
    subChatVC.m_imgUser2Avatar = self.m_imgUser2Avatar.image ? : [UIImage imageNamed:ASSETS_AVATAR_PLACEHOLDER];
    subChatVC.m_viewHeader = self.m_viewParallaxHeader;
    [self.m_viewChat addSubview:subChatVC.view];
    [self addConstraintToView:subChatVC.view];    
    
    [self addChildViewController:subChatVC];
}

- (void)addConstraintToView:(UIView *)view {
    //add constraint
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //center x
    [self.m_viewChat addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.m_viewChat
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.f
                                                                 constant:0.f]];
    
    //center y
    [self.m_viewChat addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.m_viewChat
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.f
                                                                 constant:0.f]];
    
    //equal width
    [self.m_viewChat addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.m_viewChat
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.f
                                                                 constant:0.f]];
    
    //equal height
    [self.m_viewChat addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.m_viewChat
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.f
                                                                 constant:0.f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(m_viewPopover) {
        [m_viewPopover dismiss];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)onClickBtnMenu:(id)sender {
    if(m_viewPopover) {
        [m_viewPopover dismiss];
        m_viewPopover = nil;
    } else {
        m_viewPopover = [DXPopover popover];
        m_viewPopover.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#FAFAFA" alpha:0.9f];
        m_viewPopover.cornerRadius = 8.f;
        m_viewPopover.arrowSize = CGSizeMake(20.f, 10.f);
        [m_viewPopover showAtView:sender withContentView:self.m_btnBlock inView:self.view];
        m_viewPopover.didDismissHandler = ^{
            m_viewPopover = nil;
        };
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnBlock:(id)sender {
    if(m_viewPopover) {
        [m_viewPopover dismiss];
        m_viewPopover = nil;
    }
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] blockChatroomWithConversationId:self.m_objChatRoom.conversation_id
                                                        UserName:[GlobalService sharedInstance].user_me.my_user.user_name
                                                       Completed:^(NSString *strResult, NSString *strError) {
                                                           if(!strError) {
                                                               SVPROGRESSHUD_SUCCESS(strResult);
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                           } else {
                                                               SVPROGRESSHUD_ERROR(strError);
                                                           }
                                                       }];
}

@end
