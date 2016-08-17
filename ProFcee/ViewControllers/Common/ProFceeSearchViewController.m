//
//  ProFceeSearchViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeSearchViewController.h"
#import "ProFceeUserTableViewCell.h"
#import "ProFceeOtherProfileViewController.h"

@interface ProFceeSearchViewController ()

@end

@implementation ProFceeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.m_tblUser.rowHeight = UITableViewAutomaticDimension;
    self.m_tblUser.estimatedRowHeight = 60.0f;
    
    self.m_tblSearchHistory.rowHeight = UITableViewAutomaticDimension;
    self.m_tblSearchHistory.estimatedRowHeight = 44.0f;
    
    UIButton *btnSelected = [self.view viewWithTag:10];
    [btnSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSelected setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#C91A25"]];
    
    if([GlobalService sharedInstance].search_history.count > 0) {
        self.m_viewSearchHistory.hidden = NO;
        self.m_imgNoSearch.hidden = YES;
        self.m_lblSearchComment.text = @"Select a search option.\nEnter search word or select from Previous Searches";
    } else {
        self.m_viewSearchHistory.hidden = YES;
    }
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

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickSearchKind:(id)sender {
    self.m_tblUser.hidden = YES;
    self.m_tblTrend.hidden = YES;
    self.m_searchBar.text = @"";
    
    for(int nIndex = 10; nIndex < 14; nIndex++) {
        UIButton *btnKind = [self.view viewWithTag:nIndex];
        [btnKind setTitleColor:[UIColor hx_colorWithHexRGBAString:@"#C91A25"] forState:UIControlStateNormal];
        [btnKind setBackgroundColor:[UIColor clearColor]];
    }
    
    UIButton *btnSelected = (UIButton *)sender;
    [btnSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSelected setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#C91A25"]];
    
    m_typeSearch = (int)btnSelected.tag - 10;
    
    if(m_typeSearch == SEARCH_USER_BY_EMAIL) {
        self.m_searchBar.keyboardType = UIKeyboardTypeEmailAddress;
    } else {
        self.m_searchBar.keyboardType = UIKeyboardTypeDefault;
    }

    [self.m_searchBar reloadInputViews];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.m_searchBar resignFirstResponder];
    
    if(self.m_searchBar.text.length > 0) {
        [[GlobalService sharedInstance] addSearchHistory:self.m_searchBar.text];
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] searchKeyword:self.m_searchBar.text.lowercaseString
                                          WithKind:m_typeSearch
                                         Completed:^(NSArray *aryResult, NSString *strError) {
                                             if(!strError) {
                                                 SVPROGRESSHUD_DISMISS;
                                                 if(aryResult.count > 0) {
                                                     self.m_viewSearchHistory.hidden = YES;
                                                     
                                                     if(m_typeSearch == SEARCH_USER_BY_NAME
                                                        || m_typeSearch == SEARCH_USER_BY_EMAIL) {
                                                         self.m_tblUser.hidden = NO;
                                                         self.m_tblTrend.hidden = YES;
                                                         
                                                         m_aryUsers = aryResult;
                                                         [self.m_tblUser reloadData];
                                                     } else {
                                                         self.m_tblTrend.hidden = NO;
                                                         self.m_tblUser.hidden = YES;
                                                         
                                                         self.m_aryTrendInfos = aryResult;
                                                         [self.m_tblTrend reloadData];
                                                     }
                                                     
                                                 } else {
                                                     self.m_tblTrend.hidden = YES;
                                                     self.m_tblUser.hidden = YES;
                                                     self.m_viewSearchHistory.hidden = NO;
                                                     self.m_imgNoSearch.hidden = NO;
                                                     self.m_lblSearchComment.text = @"No result! Try a new option or new search word";
                                                 }
                                             } else {
                                                 SVPROGRESSHUD_ERROR(strError);
                                             }
                                         }];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.m_viewSearchHistory.hidden = YES;
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableView isEqual:self.m_tblUser]) {
        return m_aryUsers.count;
    } else if([tableView isEqual:self.m_tblSearchHistory]) {
        return [GlobalService sharedInstance].search_history.count;
    } else {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.m_tblUser]) {
        ProFceeUserInfoObj *objUserInfo = m_aryUsers[indexPath.row];
        
        ProFceeUserTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProFceeUserTableViewCell class])
                                                                       owner:nil
                                                                     options:nil][0];
        [cell setViewsWithUserInfoObj:objUserInfo];
        
        return cell;
    } else if([tableView isEqual:self.m_tblSearchHistory]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryTableViewCell"];
        UILabel *lblHistory = [cell viewWithTag:10];
        lblHistory.text = [GlobalService sharedInstance].search_history[indexPath.row];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        return cell;
        
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.m_tblUser]) {
        ProFceeUserInfoObj *objUserInfo = m_aryUsers[indexPath.row];
        ProFceeOtherProfileViewController *otherProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProFceeOtherProfileViewController class])];
        otherProfileVC.m_selectedUser = objUserInfo.user_info_user;
        [self.navigationController pushViewController:otherProfileVC animated:YES];
    } else if([tableView isEqual:self.m_tblSearchHistory]) {
        self.m_searchBar.text = [GlobalService sharedInstance].search_history[indexPath.row];
        self.m_viewSearchHistory.hidden = YES;
        
        [self searchBarSearchButtonClicked:self.m_searchBar];
    }
}

@end
