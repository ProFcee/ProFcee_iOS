//
//  ProFceeAgreesViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/4/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeAgreesViewController.h"
#import "ProFceeUserTableViewCell.h"

@interface ProFceeAgreesViewController ()

@end

@implementation ProFceeAgreesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tblAgrees.rowHeight = UITableViewAutomaticDimension;
    self.m_tblAgrees.estimatedRowHeight = 60.0f;
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] getTrendAgrees:self.m_selectedTrend.trend_id
                                      Completed:^(NSArray *aryUserInfos, NSString *strError) {
                                          if(!strError) {
                                              SVPROGRESSHUD_DISMISS;
                                              m_aryAgrees = aryUserInfos;
                                              m_aryUserStatus = [[NSMutableArray alloc] init];
                                              for(int nIndex = 0; nIndex < m_aryAgrees.count; nIndex++) {
                                                  [m_aryUserStatus addObject:[NSNumber numberWithBool:NO]];
                                              }
                                              
                                              [self.m_tblAgrees reloadData];
                                          } else {
                                              SVPROGRESSHUD_ERROR(strError);
                                          }
                                      }];
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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnSend:(id)sender {
    [self.m_txtMessage resignFirstResponder];
    
    if(self.m_txtMessage.text.length > 0) {
        NSMutableArray *aryUserIds = [[NSMutableArray alloc] init];
        for(int nIndex = 0; nIndex < m_aryAgrees.count; nIndex++) {
            if([m_aryUserStatus[nIndex] boolValue]) {
                ProFceeUserInfoObj *objUserInfo = m_aryAgrees[nIndex];
                [aryUserIds addObject:objUserInfo.user_info_user.user_id];
            }
        }
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] createChatRoom:aryUserIds
                                            TrendId:self.m_selectedTrend.trend_id
                                            Message:self.m_txtMessage.text
                                          Completed:^(NSString *strResult, NSString *strError) {
                                              if(!strError) {
                                                  SVPROGRESSHUD_DISMISS;
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  SVPROGRESSHUD_ERROR(strError);
                                              }
                                          }];
    } else {
        [self.view makeToast:TOAST_MESSAGE_NO_MESSAGE duration:2.f position:CSToastPositionCenter];
    }
}

- (IBAction)onTapSelectAll:(id)sender {
    self.m_btnSelectAll.selected = !self.m_btnSelectAll.selected;
    [m_aryUserStatus removeAllObjects];
    for(int nIndex = 0; nIndex < m_aryAgrees.count; nIndex++) {
        [m_aryUserStatus addObject:[NSNumber numberWithBool:self.m_btnSelectAll.selected]];
    }
    
    [self.m_tblAgrees reloadData];
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
    return m_aryAgrees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeUserInfoObj *objUserInfo = m_aryAgrees[indexPath.row];
        
    ProFceeUserTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProFceeUserTableViewCell class])
                                                                   owner:nil
                                                                 options:nil][1];
    [cell setViewsWithUserInfoObj:objUserInfo];
    cell.m_btnCheck.selected = [m_aryUserStatus[indexPath.row] boolValue];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [m_aryUserStatus replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:![m_aryUserStatus[indexPath.row] boolValue]]];
    
    ProFceeUserTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.m_btnCheck.selected = [m_aryUserStatus[indexPath.row] boolValue];
    
    [self checkSelectAllStatus];
}

- (void)checkSelectAllStatus {
    BOOL isAllSelected = YES;
    for(int nIndex = 0; nIndex < m_aryUserStatus.count; nIndex++) {
        if(![m_aryUserStatus[nIndex] boolValue]) {
            isAllSelected = NO;
            break;
        }
    }
    
    self.m_btnSelectAll.selected = isAllSelected;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    if(string.length == 0)
        return YES;
    
    if(textView.text.length == 2000)
        return NO;
    
    return YES;
}

@end
