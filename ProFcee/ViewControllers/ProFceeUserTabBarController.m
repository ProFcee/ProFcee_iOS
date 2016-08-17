//
//  ProFceeUserTabBarController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeUserTabBarController.h"
#import <RDVTabBarController/RDVTabBarItem.h>
#import "ProFceeMeViewController.h"

@interface ProFceeUserTabBarController ()

@end

@implementation ProFceeUserTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UINavigationController *homeNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeHomeNavigationController"];
    UINavigationController *prophecyNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeProphecyNavigationController"];
    UINavigationController *postNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceePostNavigationController"];
    UINavigationController *messageNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeMessageNavigationController"];
    UINavigationController *meNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeMeNavigationController"];
    
    self.viewControllers = @[homeNC, prophecyNC, postNC, messageNC, meNC];
    
    NSArray *aryTitles = @[@"Home", @"Prophecies", @"", @"Messages", @"Me"];
    
    for(int nIndex = 0; nIndex < self.tabBar.items.count; nIndex++) {
        RDVTabBarItem *item = self.tabBar.items[nIndex];
        
        if(nIndex == USER_POST_TABBAR_INDEX) {
            UIImage *imgNormal = [UIImage imageNamed:@"tabbar_icon_post"];
            [item setFinishedSelectedImage:imgNormal withFinishedUnselectedImage:imgNormal];
        } else {
            item.title = aryTitles[nIndex];
            
            UIImage *imgNormal = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_icon_%@_normal", [aryTitles[nIndex] lowercaseString]]];
            UIImage *imgSelected = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_icon_%@_selected", [aryTitles[nIndex] lowercaseString]]];
            [item setFinishedSelectedImage:imgSelected withFinishedUnselectedImage:imgNormal];
            
            item.selectedTitleAttributes = @{
                                             NSFontAttributeName:               [UIFont fontWithName:@".SFUIText-Regular"
                                                                                                size:10.f],
                                             NSForegroundColorAttributeName:    [UIColor hx_colorWithHexRGBAString:@"#C91A25"]
                                             };
            item.unselectedTitleAttributes = @{
                                               NSFontAttributeName:               [UIFont fontWithName:@".SFUIText-Regular"
                                                                                                  size:10.f],
                                               NSForegroundColorAttributeName:    [UIColor hx_colorWithHexRGBAString:@"#929292"]
                                               };
        }
    }
    
    [self.tabBar setHeight:50.f];
    [GlobalService sharedInstance].user_tabbar = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onTokenExpired)
                                                 name:USER_NOTIFICATION_TOKEN_EXPIRED
                                               object:nil];
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

- (void)onTokenExpired {
    UINavigationController *meNC = self.viewControllers[USER_ME_TABBAR_INDEX];
    ProFceeMeViewController *meVC = meNC.viewControllers[0];
    
    [meVC onClickBtnLogOut:nil];
}

@end
