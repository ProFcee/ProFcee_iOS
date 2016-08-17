//
//  ProFceeSettingsViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeSettingsViewController.h"

@interface ProFceeSettingsViewController ()

@end

@implementation ProFceeSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.m_tblSettings.rowHeight = UITableViewAutomaticDimension;
    self.m_tblSettings.estimatedRowHeight = 44.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGotSettings) name:USER_NOTIFICATION_GOT_SETTINGS object:nil];
}

- (void)onGotSettings {
    [self.m_tblSettings reloadData];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [GlobalService sharedInstance].user_me.my_settings.arySettings.count + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section < 2) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40.f)];
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15.f, 15.f, CGRectGetWidth(self.view.frame) - 20.f, 20.f)];
        lblTitle.text = section == 0 ? @"MOBILE / EMAIL NOTIFICATIONS" : @"UPDATES FROM PROFCEE";
        lblTitle.font = [UIFont fontWithName:@".SFUIText-Regular" size:13.f];
        lblTitle.textColor = [UIColor hx_colorWithHexRGBAString:@"#6D6D72"];
        [headerView addSubview:lblTitle];
        
        return headerView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section < 2) {
        return 40.f;
    } else {
        return 20.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == [GlobalService sharedInstance].user_me.my_settings.arySettings.count) {
        return 2;
    } else {
        return [[GlobalService sharedInstance].user_me.my_settings.arySettings[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeSettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProFceeSettingsTableViewCell class])];
    
    if([GlobalService sharedInstance].user_me.my_settings.arySettings.count == indexPath.section) {
        if(indexPath.row == 0) {
            cell.m_lblTitle.text = @"Change password";
        } else {
            cell.m_lblTitle.text = @"Deactive account";
        }
        
        cell.m_lblTitle.textColor = [UIColor hx_colorWithHexRGBAString:@"#C91A25"];
        cell.m_swtValue.hidden = YES;
        
    } else {
        NSDictionary *dicSettings = [GlobalService sharedInstance].user_me.my_settings.arySettings[indexPath.section][indexPath.row];
        
        [cell setViewsWithDictionary:dicSettings onIndexPath:indexPath];
        cell.delegate = self;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == [GlobalService sharedInstance].user_me.my_settings.arySettings.count) {
        if(indexPath.row == 0) {    // update password
            UIViewController *updatePasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeUpdatePasswordViewController"];
            [self.navigationController pushViewController:updatePasswordVC animated:YES];
        } else {    // deactive account
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] deactivateUser:^(NSString *strResult, NSString *strError) {
                if(!strError) {
                    SVPROGRESSHUD_SUCCESS(strResult);
                } else {
                    SVPROGRESSHUD_ERROR(strError);
                }
            }];
        }
    }
}

#pragma mark - ProFceeSettingsTableViewCellDelegate
- (void)onSwitchValueChanged:(BOOL)isOn onIndexPath:(NSIndexPath *)indexPath {
    [[GlobalService sharedInstance].user_me.my_settings setOn:isOn onIndexPath:indexPath];
    [[WebService sharedInstance] updateUserSettings:[GlobalService sharedInstance].user_me.my_settings
                                          Completed:^(NSString *strResult, NSString *strError) {
                                              if(!strError) {
                                                  NSLog(@"%@", strResult);
                                              } else {
                                                  NSLog(@"%@", strError);
                                              }
                                          }];
}

@end
