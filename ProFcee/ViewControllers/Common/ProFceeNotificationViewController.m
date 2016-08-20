//
//  ProFceeNotificationViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeNotificationViewController.h"
#import "ProFceeOtherProfileViewController.h"

@interface ProFceeNotificationViewController ()

@end

@implementation ProFceeNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([GlobalService sharedInstance].user_me.getNewNotificationCount > 0) {
        [[WebService sharedInstance] markNotificationsAsRead:^(NSString *strResult, NSString *strError) {
            if(!strError) {
                NSLog(@"%@", strResult);
                [[GlobalService sharedInstance].user_me markNotificationsAsRead];
            } else {
                NSLog(@"%@", strError);
            }
        }];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    self.m_tblNotification.rowHeight = UITableViewAutomaticDimension;
    self.m_tblNotification.estimatedRowHeight = 70.f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGotNotifications) name:USER_NOTIFICATION_GOT_NOTIFICATIONS object:nil];
}

- (void)onGotNotifications {
    [self.m_tblNotification reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[GlobalService sharedInstance].user_tabbar setTabBarHidden:NO];
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

- (IBAction)onClickBtnClearAll:(id)sender {
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] clearUserNotifications:^(NSString *strResult, NSString *strError) {
        if(!strError) {
            SVPROGRESSHUD_DISMISS;
            
            [[GlobalService sharedInstance].user_me removeAllNotifications];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            SVPROGRESSHUD_ERROR(strError);
        }
    }];
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    return [GlobalService sharedInstance].user_me.my_notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeNotificationObj *objNotification = [GlobalService sharedInstance].user_me.my_notifications[indexPath.row];
    
    ProFceeNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProFceeNotificationTableViewCell class])];
    [cell setViewsWithNotificationObj:objNotification];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        ProFceeNotificationObj *objNotification = [GlobalService sharedInstance].user_me.my_notifications[indexPath.row];
        [[GlobalService sharedInstance].user_me removeNotificationWithId:objNotification.notification_id];
        
        [self.m_tblNotification deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[WebService sharedInstance] removeNotificationWithId:objNotification.notification_id
                                                    Completed:^(NSString *strResult, NSString *strError) {
                                                        if(!strError) {
                                                            NSLog(@"%@", strResult);
                                                        } else {
                                                            NSLog(@"%@", strError);
                                                        }
                                                    }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProFceeNotificationObj *objNotification = [GlobalService sharedInstance].user_me.my_notifications[indexPath.row];
    switch (objNotification.notification_type) {
        case PROFCEE_PUSH_TYPE_AGREE_TREND:
        case PROFCEE_PUSH_TYPE_REPORT_TREND:
        case PROFCEE_PUSH_TYPE_SHARE_TREND:
            [GlobalService sharedInstance].user_tabbar.selectedIndex = USER_ME_TABBAR_INDEX;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_SHOW_TREND
                                                                object:nil
                                                              userInfo:@{@"object_id": objNotification.notification_object_id}];
            break;
            
        case PROFCEE_PUSH_TYPE_BLOCK_USER:
            [GlobalService sharedInstance].user_tabbar.selectedIndex = USER_MESSAGE_TABBAR_INDEX;
            break;
            
        case PROFCEE_PUSH_TYPE_SEND_MESSAGE:
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] getReplyById:objNotification.notification_object_id
                                            Completed:^(ProFceeReplyObj *objReply, NSString *strError) {
                                                if(!strError) {
                                                    SVPROGRESSHUD_DISMISS;
                                                    [GlobalService sharedInstance].user_tabbar.selectedIndex = USER_MESSAGE_TABBAR_INDEX;
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_SHOW_MESSAGE
                                                                                                        object:nil
                                                                                                      userInfo:@{@"object_id": objReply.reply_conversation_id}];
                                                } else {
                                                    SVPROGRESSHUD_ERROR(strError);
                                                }
                                            }];
            break;
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - ProFceeNotificationTableViewCellDelegate
- (void)onTapUserAvatar:(ProFceeNotificationObj *)objNotification {
    ProFceeOtherProfileViewController *otherProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProFceeOtherProfileViewController class])];
    otherProfileVC.m_selectedUser = objNotification.notification_user;
    [self.navigationController pushViewController:otherProfileVC animated:YES];
}

@end
