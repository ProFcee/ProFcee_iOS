//
//  ProFceeOtherProfileViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeOtherProfileViewController.h"

@interface ProFceeOtherProfileViewController ()

@end

@implementation ProFceeOtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.m_lblUserName.text = self.m_selectedUser.user_name;
    [self.m_imgUserBanner setImageWithUrl:self.m_selectedUser.bannerUrl
                          withPlaceholder:nil];

    [self.m_imgUserAvatar setImageWithUrl:self.m_selectedUser.avatarUrl
                          withPlaceholder:nil];
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] getUserTrends:self.m_selectedUser.user_id
                                     Completed:^(NSArray *aryTrendInfos, NSString *strError) {
                                         if(strError) {
                                             SVPROGRESSHUD_ERROR(strError);
                                         } else {
                                             SVPROGRESSHUD_DISMISS;
                                             self.m_aryTrendInfos = aryTrendInfos;
                                             [self.m_tblTrend reloadData];
                                         }
                                     }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.m_imgUserAvatar.layer.masksToBounds = YES;
    self.m_imgUserAvatar.layer.cornerRadius = CGRectGetHeight(self.m_imgUserAvatar.frame) / 2.f;
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

#pragma mark - ProFceeTrendTableViewCellDelegate
- (void)onTapTrendOwnerAvatar:(NSInteger)row {
    NSLog(@"Ignore tapping user avatar");
}

@end
