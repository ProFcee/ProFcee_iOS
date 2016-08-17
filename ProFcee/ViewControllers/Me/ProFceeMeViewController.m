//
//  ProFceeMeViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeMeViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <TwitterKit/TwitterKit.h>

#define TREND_USER_VIEW_HEIGHT          20
#define TREND_ACTION_VIEW_HEIGHT        45

@interface ProFceeMeViewController ()

@end

@implementation ProFceeMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tblTrend.rowHeight = UITableViewAutomaticDimension;
    self.m_tblTrend.estimatedRowHeight = 110.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[GlobalService sharedInstance].user_tabbar setTabBarHidden:NO];
    
    [self.m_imgUserBanner setImageWithUrl:[GlobalService sharedInstance].user_me.my_user.bannerUrl
                          withPlaceholder:nil];
    
    self.m_imgUserAvatar.layer.masksToBounds = YES;
    self.m_imgUserAvatar.layer.cornerRadius = CGRectGetHeight(self.m_imgUserAvatar.frame) / 2.f;
    [self.m_imgUserAvatar setImageWithUrl:[GlobalService sharedInstance].user_me.my_user.avatarUrl
                          withPlaceholder:nil];
    
    [[WebService sharedInstance] getUserTrends:[GlobalService sharedInstance].user_me.my_user.user_id
                                     Completed:^(NSArray *aryTrendInfos, NSString *strError) {
                                         if(!strError) {
                                             m_aryMyTrends = [aryTrendInfos mutableCopy];
                                             if(m_aryMyTrends.count > 1) {
                                                 [self.m_segTrend setTitle:[NSString stringWithFormat:@"%d trends", (int)m_aryMyTrends.count]
                                                         forSegmentAtIndex:0];
                                             } else if (m_aryMyTrends.count == 1) {
                                                 [self.m_segTrend setTitle:@"1 trend" forSegmentAtIndex:0];
                                             } else {
                                                 [self.m_segTrend setTitle:@"No trends"
                                                         forSegmentAtIndex:0];
                                             }
                                             
                                             [self onSwitchSegment:nil];
                                         } else {
                                             NSLog(@"%@", strError);
                                         }
                                     }];
    
    [[WebService sharedInstance] getUserAgreedTrends:[GlobalService sharedInstance].user_me.my_user.user_id
                                           Completed:^(NSArray *aryTrendInfos, NSString *strError) {
                                               if(!strError) {
                                                   m_aryMyAgreedTrends = aryTrendInfos;
                                                   if(m_aryMyAgreedTrends.count > 1) {
                                                       [self.m_segTrend setTitle:[NSString stringWithFormat:@"%d agrees", (int)m_aryMyAgreedTrends.count]
                                                               forSegmentAtIndex:1];
                                                   } else if (m_aryMyAgreedTrends.count == 1) {
                                                       [self.m_segTrend setTitle:@"1 agree" forSegmentAtIndex:1];
                                                   } else {
                                                       [self.m_segTrend setTitle:@"No agrees"
                                                               forSegmentAtIndex:1];
                                                   }
                                                   
                                                   [self onSwitchSegment:nil];
                                               } else {
                                                   NSLog(@"%@", strError);
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

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_segTrend.selectedSegmentIndex == 0) {
        ProFceeTrendInfoObj *objTrendInfo = self.m_aryTrendInfos[indexPath.row];
        
        ProFceeTrendTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProFceeTrendTableViewCell class])
                                                                        owner:nil
                                                                      options:nil][1];
        [cell setViewsWithTrendInfoObj:objTrendInfo atRow:indexPath.row];
        cell.delegate = self;
        [cell setBackgroundColor:[UIColor clearColor]];
        
        CGFloat fTrendImageHeight = 0;
        if(objTrendInfo.trend_info_trend.trend_image.length > 0) {
            fTrendImageHeight = (CGRectGetWidth(self.view.frame) - 20) * TREND_IMAGE_RATIO;
        }
        cell.m_constraintTrendImageHeight.constant = fTrendImageHeight;
        
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - ProFceeTrendTableViewCellDelegate

- (void)onClickBtnReportAtRow:(NSInteger)row {
    if(self.m_segTrend.selectedSegmentIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                        message:@"Are you sure you want to remove this trend?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        alert.tag = row;
        [alert show];
    } else {
        [super onClickBtnReportAtRow:row];
    }
}

- (IBAction)onClickBtnEditProfile:(id)sender {
    UIViewController *editProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeEditProfileViewController"];
    [self.navigationController pushViewController:editProfileVC animated:YES];
}

- (IBAction)onClickBtnLogOut:(id)sender {
    [[GlobalService sharedInstance] removeMe];
    [[GlobalService sharedInstance].user_tabbar.navigationController popViewControllerAnimated:NO];
    
    //Social logout
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    
    [[GIDSignIn sharedInstance] signOut];
    
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    [store logOutUserID:store.session.userID];
    
    [[WebService sharedInstance] logoutUserWithId:[GlobalService sharedInstance].user_me.my_user.user_id
                                        Completed:^(NSString *strResult, NSString *strError) {
                                            if(!strError) {
                                                NSLog(@"%@", strResult);
                                            } else {
                                                NSLog(@"%@", strError);
                                            }
                                        }];
}

- (IBAction)onSwitchSegment:(id)sender {
    if(self.m_segTrend.selectedSegmentIndex == 0) {
        self.m_aryTrendInfos = m_aryMyTrends;
    } else {
        self.m_aryTrendInfos = m_aryMyAgreedTrends;
    }
    
    [self.m_tblTrend reloadData];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(self.m_segTrend.selectedSegmentIndex == 0) {
        if(buttonIndex == 1) {
            ProFceeTrendInfoObj *objTrendInfo = self.m_aryTrendInfos[alertView.tag];
            
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] deleteTrend:objTrendInfo.trend_info_trend.trend_id
                                           Completed:^(NSString *strResult, NSString *strError) {
                                               if(!strError) {
                                                   SVPROGRESSHUD_DISMISS;
                                                   [m_aryMyTrends removeObject:objTrendInfo];
                                                   
                                                   if(m_aryMyTrends.count > 1) {
                                                       [self.m_segTrend setTitle:[NSString stringWithFormat:@"%d trends", (int)m_aryMyTrends.count]
                                                               forSegmentAtIndex:0];
                                                   } else if (m_aryMyTrends.count == 1) {
                                                       [self.m_segTrend setTitle:@"1 trend" forSegmentAtIndex:0];
                                                   } else {
                                                       [self.m_segTrend setTitle:@"No trends"
                                                               forSegmentAtIndex:0];
                                                   }
                                                   
                                                   self.m_aryTrendInfos = m_aryMyTrends;
                                                   [self.m_tblTrend reloadData];
                                               } else {
                                                   SVPROGRESSHUD_ERROR(strError);
                                               }
                                           }];
        }
    } else {
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

@end
