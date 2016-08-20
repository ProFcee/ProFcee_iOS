//
//  ProFceeMessageViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeMessageViewController.h"
#import "ProFceeUserTableViewCell.h"
#import "ProFceeChatViewController.h"

@interface ProFceeMessageViewController ()

@end

@implementation ProFceeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tblChatRooms.rowHeight = UITableViewAutomaticDimension;
    self.m_tblChatRooms.estimatedRowHeight = 60.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onGotNewMessage)
                                                 name:USER_NOTIFICATION_GOT_MESSAGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMessage:)
                                                 name:USER_NOTIFICATION_SHOW_MESSAGE
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createChatroom)
                                                 name:USER_NOTIFICATION_CREATE_CHATROOM
                                               object:nil];
    
    m_aryTmpChatRooms = [[NSMutableArray alloc] init];
    
    SVPROGRESSHUD_PLEASE_WAIT;
}

- (void)onGotNewMessage {
    [[WebService sharedInstance] getChatrooms:^(NSArray *aryChatRooms, NSString *strError) {
        if(!strError) {
            SVPROGRESSHUD_DISMISS;
            m_aryChatRooms = [aryChatRooms mutableCopy];
            [self onChangedSegment:self.m_segKind];
        } else {
            SVPROGRESSHUD_ERROR(strError);
        }
    }];
}

- (void)showMessage:(NSNotification *)notification {
    for(int nIndex = 0; nIndex < m_aryChatRooms.count; nIndex++) {
        ProFceeChatRoomObj *objChatRoom = m_aryChatRooms[nIndex];
        if(objChatRoom.conversation_id.intValue == [notification.userInfo[@"object_id"] intValue]) {
            ProFceeChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProFceeChatViewController class])];
            chatVC.m_objChatRoom = objChatRoom;
            [self.navigationController pushViewController:chatVC animated:YES];
            
            break;
        }
    }
}

- (void)createChatroom {
    self.m_segKind.selectedSegmentIndex = 2;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self onGotNewMessage];
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

- (IBAction)onChangedSegment:(id)sender {
    [m_aryTmpChatRooms removeAllObjects];
    UISegmentedControl *segKind = (UISegmentedControl *)sender;
    if(segKind.selectedSegmentIndex == 0) {
        m_aryTmpChatRooms = [NSMutableArray arrayWithArray:m_aryChatRooms];
    } else if(segKind.selectedSegmentIndex == 1) {
        for(ProFceeChatRoomObj *objChatRoom in m_aryChatRooms) {
            if(objChatRoom.conversation_agreed) {
                [m_aryTmpChatRooms addObject:objChatRoom];
            }
        }
    } else {
        for(ProFceeChatRoomObj *objChatRoom in m_aryChatRooms) {
            if(!objChatRoom.conversation_agreed) {
                [m_aryTmpChatRooms addObject:objChatRoom];
            }
        }
    }
    
    if(m_aryTmpChatRooms.count > 0) {
        self.m_tblChatRooms.hidden = NO;
        self.m_viewNoMessage.hidden = YES;
        
        [self.m_tblChatRooms reloadData];
    } else {
        self.m_tblChatRooms.hidden = YES;
        self.m_viewNoMessage.hidden = NO;
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_aryTmpChatRooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeChatRoomObj *objChatRoom = m_aryTmpChatRooms[indexPath.row];
    ProFceeUserTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProFceeUserTableViewCell class])
                                                                   owner:nil
                                                                 options:nil][0];
    [cell setViewsWithUserInfoObj:objChatRoom.conversation_user];
    
    if(objChatRoom.conversation_new.intValue > 0) {
        cell.m_lblBadge.hidden = NO;
        cell.m_lblBadge.text = [NSString stringWithFormat:@"%d", objChatRoom.conversation_new.intValue];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProFceeChatRoomObj *objChatRoom = m_aryTmpChatRooms[indexPath.row];
    ProFceeChatViewController *chatVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProFceeChatViewController class])];
    chatVC.m_objChatRoom = objChatRoom;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                        message:@"Are you sure you want to remove this conversation?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        alert.tag = indexPath.row;
        [alert show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        ProFceeChatRoomObj *objChatRoom = m_aryTmpChatRooms[alertView.tag];
        [m_aryChatRooms removeObject:objChatRoom];
        [m_aryTmpChatRooms removeObject:objChatRoom];
        
        [self.m_tblChatRooms deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:alertView.tag inSection:0]]
                                   withRowAnimation:UITableViewRowAnimationFade];
        
        [[WebService sharedInstance] deleteConversation:objChatRoom.conversation_id
                                              Completed:^(NSString *strResult, NSString *strError) {
                                                  if(!strError) {
                                                      NSLog(@"%@", strResult);
                                                  } else {
                                                      NSLog(@"%@", strError);
                                                  }
                                              }];
    }
}

@end
