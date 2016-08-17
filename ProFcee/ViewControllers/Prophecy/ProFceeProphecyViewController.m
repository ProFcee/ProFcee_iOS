//
//  ProFceeProphecyViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeProphecyViewController.h"

@interface ProFceeProphecyViewController ()

@end

@implementation ProFceeProphecyViewController

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
    TREND_TYPE type = TREND_NORMAL_TOP_RATED;
    if([GlobalService sharedInstance].user_me) {
        type = TREND_USER_TOP_RATED;
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
