//
//  ProFceeTrendViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/30/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeTrendViewController.h"
#import "ProFceeOtherProfileViewController.h"
#import "ProFceeAgreesViewController.h"
#import <Social/Social.h>

#define TREND_USER_VIEW_HEIGHT          60
#define TREND_ACTION_VIEW_HEIGHT        45

@interface ProFceeTrendViewController ()

@end

@implementation ProFceeTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_tblTrend.rowHeight = UITableViewAutomaticDimension;
    self.m_tblTrend.estimatedRowHeight = 150.0f;
    self.m_tblTrend.delegate = self;
    self.m_tblTrend.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGotNotifications) name:USER_NOTIFICATION_GOT_NOTIFICATIONS object:nil];
}

- (void)onGotNotifications {
    if([GlobalService sharedInstance].user_me.getNewNotificationCount > 0) {
        self.m_lblNotification.hidden = NO;
        self.m_lblNotification.text = [NSString stringWithFormat:@"%d", (int)[GlobalService sharedInstance].user_me.getNewNotificationCount];
    } else {
        self.m_lblNotification.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self onGotNotifications];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(m_viewPopover) {
        [m_viewPopover dismiss];
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

- (IBAction)onClickBtnSearch:(id)sender {
    if([GlobalService sharedInstance].user_me) {
        UIViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeSearchViewController"];
        [self.navigationController pushViewController:searchVC animated:YES];
    } else {
        [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_LOGIN_TABBAR_INDEX;
    }
}

- (IBAction)onClickBtnMore:(UIButton *)sender {
    ProFceeMorePopoverView *viewMore = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProFceeMorePopoverView class])
                                                                      owner:nil
                                                                    options:nil] firstObject];
    UIView *view = [[UIView alloc] initWithFrame:viewMore.frame];
    [view addSubview:viewMore];
    viewMore.delegate = self;
    
    if(m_viewPopover) {
        [m_viewPopover dismiss];
        m_viewPopover = nil;
    } else {
        sender.selected = YES;
        m_viewPopover = [DXPopover popover];
        m_viewPopover.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#FAFAFA" alpha:0.9f];
        m_viewPopover.cornerRadius = 8.f;
        m_viewPopover.arrowSize = CGSizeMake(20.f, 10.f);
        [m_viewPopover showAtView:sender withContentView:view inView:self.view];
        m_viewPopover.didDismissHandler = ^{
            m_viewPopover = nil;
            sender.selected = NO;
        };
    }
}

- (IBAction)onClickBtnNotifications:(id)sender {
    if([GlobalService sharedInstance].user_me) {
        UIViewController *notificationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeNotificationViewController"];
        [self.navigationController pushViewController:notificationVC animated:YES];
    } else {
        [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_LOGIN_TABBAR_INDEX;
    }
}

#pragma mark - ProfceeMorePopoverViewDelegate

- (void)didSelectedItem:(POPOVER_MORE_BUTTON_INDEX)index {
    switch (index) {
        case POPOVER_MORE_SETTINGS: {
            if([GlobalService sharedInstance].user_me) {
                UIViewController *settingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeSettingsViewController"];
                UINavigationController *rootNC = (UINavigationController *)[GlobalService sharedInstance].app_delegate.window.rootViewController;
                [rootNC pushViewController:settingsVC animated:YES];
            } else {
                [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_LOGIN_TABBAR_INDEX;
            }
            break;
        }
        case POPOVER_MORE_ABOUT_US: {
            UIViewController *aboutUsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeAboutUsViewController"];
            UINavigationController *rootNC = (UINavigationController *)[GlobalService sharedInstance].app_delegate.window.rootViewController;
            [rootNC pushViewController:aboutUsVC animated:YES];
            break;
        }
        case POPOVER_MORE_TERMS:
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:PROFCEE_TERMS_URL]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PROFCEE_TERMS_URL]];
            }
            break;
            
        case POPOVER_MORE_PRIVACY:
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:PROFCEE_PRIVACY_URL]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PROFCEE_PRIVACY_URL]];
            }
            break;
    }
    
    if(m_viewPopover) {
        [m_viewPopover dismiss];
        m_viewPopover = nil;
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
    return self.m_aryTrendInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeTrendInfoObj *objTrendInfo = self.m_aryTrendInfos[indexPath.row];
    
    ProFceeTrendTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProFceeTrendTableViewCell class])
                                                                    owner:nil
                                                                  options:nil][0];
    [cell setViewsWithTrendInfoObj:objTrendInfo atRow:indexPath.row];
    cell.delegate = self;
    [cell setBackgroundColor:[UIColor clearColor]];
    
    CGFloat fTrendImageHeight = 0;
    if(objTrendInfo.trend_info_trend.trend_image.length > 0) {
        fTrendImageHeight = (CGRectGetWidth(self.view.frame) - 20) * TREND_IMAGE_RATIO;
    }
    cell.m_constraintTrendImageHeight.constant = fTrendImageHeight;
    
    return cell;
}

#pragma mark - ProFceeTrendTableViewCellDelegate

- (void)onClickBtnAgreeAtRow:(NSInteger)row {
    if([GlobalService sharedInstance].user_me) {
        ProFceeTrendInfoObj *objTrendInfo = self.m_aryTrendInfos[row];
        if([GlobalService sharedInstance].user_me.my_user.user_id.intValue == objTrendInfo.trend_info_user.user_id.intValue) {
            [self.view makeToast:TOAST_MESSAGE_TREND_OWNER duration:2.f position:CSToastPositionCenter];
        } else if(objTrendInfo.trend_info_trend.trend_abused) {
            [self.view makeToast:TOAST_MESSAGE_TREND_REPORT_PAST duration:2.f position:CSToastPositionCenter];
        } else {
            ProFceeTrendTableViewCell *cell = [self.m_tblTrend cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            cell.m_btnAgree.selected = YES;
            
            objTrendInfo.trend_info_trend.trend_agreed = YES;
            [[WebService sharedInstance] agreeTrend:objTrendInfo.trend_info_trend.trend_id
                                          Completed:^(NSString *strResult, NSString *strError) {
                                              if(!strError) {
                                                  NSLog(@"%@", strResult);
                                              } else {
                                                  NSLog(@"%@", strError);
                                              }
                                          }];
        }
    } else {
        [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_LOGIN_TABBAR_INDEX;
    }
}

- (void)onClickBtnShareAtRow:(NSInteger)row {
    m_objTrendInfo = self.m_aryTrendInfos[row];
    
    if([GlobalService sharedInstance].user_me
       && m_objTrendInfo.trend_info_trend.trend_abused) {
        [self.view makeToast:TOAST_MESSAGE_TREND_REPORT_PAST duration:2.f position:CSToastPositionCenter];
    } else {
        AAShareBubbles *bubbles = [[AAShareBubbles alloc] initWithPoint:self.view.center radius:160 inView:self.view];
        bubbles.delegate = self;
        bubbles.bubbleRadius = 60.f;
        
        [bubbles addCustomButtonWithIcon:[UIImage imageNamed:@"share_icon_facebook"]
                         backgroundColor:[UIColor clearColor]
                             andButtonId:100];
        
        [bubbles addCustomButtonWithIcon:[UIImage imageNamed:@"share_icon_whatsapp"]
                         backgroundColor:[UIColor clearColor]
                             andButtonId:101];
        
        [bubbles addCustomButtonWithIcon:[UIImage imageNamed:@"share_icon_twitter"]
                         backgroundColor:[UIColor clearColor]
                             andButtonId:102];
        
        [bubbles addCustomButtonWithIcon:[UIImage imageNamed:@"share_icon_other"]
                         backgroundColor:[UIColor clearColor]
                             andButtonId:103];
        
        [bubbles show];
    }
}

- (void)onClickBtnReportAtRow:(NSInteger)row {
    if([GlobalService sharedInstance].user_me) {
        ProFceeTrendInfoObj *objTrendInfo = self.m_aryTrendInfos[row];
        if([GlobalService sharedInstance].user_me.my_user.user_id.intValue == objTrendInfo.trend_info_user.user_id.intValue) {
            [self.view makeToast:TOAST_MESSAGE_TREND_OWNER duration:2.f position:CSToastPositionCenter];
        } else if(objTrendInfo.trend_info_trend.trend_agreed) {
            [self.view makeToast:TOAST_MESSAGE_TREND_AGREE_PAST duration:2.f position:CSToastPositionCenter];
        } else if(objTrendInfo.trend_info_trend.trend_abused) {
            [self.view makeToast:TOAST_MESSAGE_TREND_REPORT_PAST duration:2.f position:CSToastPositionCenter];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                            message:@"Are you sure you want to report this trend as abuse?"
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            alert.tag = row;
            [alert show];
        }
    } else {
        [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_LOGIN_TABBAR_INDEX;
    }
}

- (void)onTapTrendOwnerAvatar:(NSInteger)row {
    if([GlobalService sharedInstance].user_me) {
        ProFceeTrendInfoObj *objTrendInfo = self.m_aryTrendInfos[row];
        ProFceeOtherProfileViewController *otherProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProFceeOtherProfileViewController class])];
        otherProfileVC.m_selectedUser = objTrendInfo.trend_info_user;
        [self.navigationController pushViewController:otherProfileVC animated:YES];
    } else {
        [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_LOGIN_TABBAR_INDEX;
    }
}

- (void)onTapUserAgrees:(NSInteger)row {
    if([GlobalService sharedInstance].user_me) {
        ProFceeTrendInfoObj *objTrendInfo = self.m_aryTrendInfos[row];
        if([GlobalService sharedInstance].user_me.my_user.user_id.intValue != objTrendInfo.trend_info_user.user_id.intValue) {
            [self.view makeToast:TOAST_MESSAGE_TREND_NOT_OWNER duration:2.f position:CSToastPositionCenter];
        } else if (objTrendInfo.trend_info_trend.trend_agrees.intValue == 0) {
            [self.view makeToast:TOAST_MESSAGE_TREND_NO_AGREES duration:2.f position:CSToastPositionCenter];
        } else {
            ProFceeAgreesViewController *agreesVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProFceeAgreesViewController class])];
            agreesVC.m_selectedTrend = objTrendInfo.trend_info_trend;
            [self.navigationController pushViewController:agreesVC animated:YES];
        }
    } else {
        [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_LOGIN_TABBAR_INDEX;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        ProFceeTrendInfoObj *objTrendInfo = self.m_aryTrendInfos[alertView.tag];
        objTrendInfo.trend_info_trend.trend_abused = YES;
        
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] reportTrend:objTrendInfo.trend_info_trend.trend_id
                                       Completed:^(NSString *strResult, NSString *strError) {
                                           if(!strError) {
                                               SVPROGRESSHUD_SUCCESS(strResult);
                                           } else {
                                               SVPROGRESSHUD_ERROR(strError);
                                           }
                                       }];
    }
}

#pragma mark - AAShareBubblesDelegate

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType {
    switch ((int)bubbleType) {
        case 100:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
                content.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.profcee.com/trend/%@", m_objTrendInfo.trend_info_trend.trend_id.stringValue]];
                [FBSDKShareDialog showFromViewController:[UIApplication sharedApplication].delegate.window.rootViewController
                                             withContent:content
                                                delegate:self];
            });
        }
            break;
            
        case 101:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *strShareText = [NSString stringWithFormat:@"\"%@\" : A Trend posted by %@ from %@ on ProFcee.",
                                          m_objTrendInfo.trend_info_trend.trend_body,
                                          m_objTrendInfo.trend_info_user.user_name,
                                          m_objTrendInfo.trend_info_trend.trend_location];
                
                NSString *shareBranchLink = [NSString stringWithFormat:@" %@ Click here www.profcee.com for more.", strShareText];
                
                NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@", shareBranchLink];
                NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
                    [[UIApplication sharedApplication] openURL: whatsappURL];
                } else {
                    // Cannot open whatsapp
                }
            });
        }
            break;
            
        case 102:
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                {
                    NSString *strShareText = [NSString stringWithFormat:@"A prediction posted on ProFcee by %@ from %@ www.profcee.com/trend/%@",
                                              m_objTrendInfo.trend_info_user.user_name,
                                              m_objTrendInfo.trend_info_trend.trend_location,
                                              m_objTrendInfo.trend_info_trend.trend_id];
                    
                    SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                    [twitter setInitialText:strShareText];
                    [self presentViewController:twitter animated:YES completion:nil];
                    
                    [twitter setCompletionHandler:^(SLComposeViewControllerResult result){
                        NSString *outout = [[NSString alloc] init];
                        
                        switch (result) {
                            case SLComposeViewControllerResultCancelled:
                                outout = @"Post Cancled";
                                break;
                            case SLComposeViewControllerResultDone:
                                outout = @"Post Done";
                                
                                [[WebService sharedInstance] shareTrend:m_objTrendInfo.trend_info_trend.trend_id
                                                              Completed:^(NSString *strResult, NSString *strError) {
                                                                  if(!strError) {
                                                                      NSLog(@"%@", strResult);
                                                                  } else {
                                                                      NSLog(@"%@", strError);
                                                                  }
                                                              }];
                                
                            default:
                                break;
                        }
                    }];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:APP_NAME
                                                                    message:@"There are no Twitter accounts configured. Go to Settings to add a Twitter account."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    
                    
                    [alert show];
                    
                }
            });
        }
            break;
            
        case 103:
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *strTitle =[NSString stringWithFormat:@"Interesting Trend on ProFcee by %@ from %@",
                                     m_objTrendInfo.trend_info_user.user_name,
                                     m_objTrendInfo.trend_info_trend.trend_location];
                
                NSString *strShareText =[NSString stringWithFormat:@"\"%@\" : A Trend posted by %@ from %@ on ProFcee.",
                                         m_objTrendInfo.trend_info_trend.trend_body,
                                         m_objTrendInfo.trend_info_user.user_name,
                                         m_objTrendInfo.trend_info_trend.trend_location];
                
                NSString *shareBranchLink = [NSString stringWithFormat:@" %@ Click here www.profcee.com for more.", strShareText];
                
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[shareBranchLink] applicationActivities:nil];
                [activityVC setValue:strTitle forKey:@"subject"];
                
                NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                               UIActivityTypeCopyToPasteboard,
                                               UIActivityTypePrint,
                                               UIActivityTypeAssignToContact,
                                               UIActivityTypeSaveToCameraRoll,
                                               UIActivityTypeAddToReadingList,
                                               UIActivityTypePostToFlickr,
                                               UIActivityTypePostToFacebook,
                                               UIActivityTypePostToTwitter,
                                               UIActivityTypePostToVimeo];
                
                activityVC.excludedActivityTypes = excludeActivities;
                
                [activityVC setCompletionWithItemsHandler:^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                    if(completed) {
                        [[WebService sharedInstance] shareTrend:m_objTrendInfo.trend_info_trend.trend_id
                                                      Completed:^(NSString *strResult, NSString *strError) {
                                                          if(!strError) {
                                                              NSLog(@"%@", strResult);
                                                          } else {
                                                              NSLog(@"%@", strError);
                                                          }
                                                      }];
                    }
                }];
                
                UIPopoverPresentationController *popPresenter = [activityVC popoverPresentationController];
                popPresenter.sourceView = self.view;
                popPresenter.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height, 1.0, 1.0);
                
                [self presentViewController:activityVC animated:YES completion:nil];
                
            });
            break;
    }
}

#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    [[WebService sharedInstance] shareTrend:m_objTrendInfo.trend_info_trend.trend_id
                                  Completed:^(NSString *strResult, NSString *strError) {
                                      if(!strError) {
                                          NSLog(@"%@", strResult);
                                      } else {
                                          NSLog(@"%@", strError);
                                      }
                                  }];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
}

@end
