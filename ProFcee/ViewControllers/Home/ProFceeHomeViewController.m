//
//  ProFceeHomeViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeHomeViewController.h"

@interface ProFceeHomeViewController ()

@end

@implementation ProFceeHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(onRefreshTrend:) forControlEvents:UIControlEventValueChanged];
    [self.m_tblTrend addSubview:refresh];
    
    SVPROGRESSHUD_PLEASE_WAIT;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self onRefreshTrend:nil];
}

- (void)onRefreshTrend:(UIRefreshControl *)refresh {
    TREND_TYPE type = TREND_NORMAL;
    if([GlobalService sharedInstance].user_me) {
        type = TREND_PICK;
    }
        
    [[WebService sharedInstance] getTrendByType:type
                                      Completed:^(NSArray *aryTrendInfos, NSString *strError) {
                                           [refresh endRefreshing];
                                           if(strError) {
                                               SVPROGRESSHUD_ERROR(strError);
                                           } else {
                                               SVPROGRESSHUD_DISMISS;
                                               self.m_aryTrendInfos = aryTrendInfos;
                                               [self.m_tblTrend reloadData];
                                           }
                                       }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[GlobalService sharedInstance].user_tabbar setTabBarHidden:NO];
    [[GlobalService sharedInstance].normal_tabbar setTabBarHidden:NO];
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

@end
