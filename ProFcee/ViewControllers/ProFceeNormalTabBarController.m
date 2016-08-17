//
//  ProFceeNormalTabBarController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeNormalTabBarController.h"
#import <RDVTabBarController/RDVTabBarItem.h>

@interface ProFceeNormalTabBarController ()

@end

@implementation ProFceeNormalTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIViewController *signUpNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeSignUpNavigationController"];
    UINavigationController *homeNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeHomeNavigationController"];
    UINavigationController *prophecyNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeProphecyNavigationController"];
    UIViewController *logInNC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeLogInNavigationController"];
    
    self.viewControllers = @[signUpNC, homeNC, prophecyNC, logInNC];
    
    NSArray *aryTitles = @[@"SIGN UP", @"Home", @"Prophecies", @"LOG IN"];
    
    for(int nIndex = 0; nIndex < self.tabBar.items.count; nIndex++) {
        RDVTabBarItem *item = self.tabBar.items[nIndex];
        item.title = aryTitles[nIndex];
        
        if(nIndex == NORMAL_LOGIN_TABBAR_INDEX || nIndex == NORMAL_SIGNUP_TABBAR_INDEX) {
            item.selectedTitleAttributes = @{
                                             NSFontAttributeName:               [UIFont fontWithName:@".SFUIText-Bold"
                                                                                                size:17.f],
                                             NSForegroundColorAttributeName:    [UIColor hx_colorWithHexRGBAString:@"#C91A25"]
                                             };
            item.unselectedTitleAttributes = @{
                                               NSFontAttributeName:               [UIFont fontWithName:@".SFUIText-Bold"
                                                                                                  size:17.f],
                                               NSForegroundColorAttributeName:    [UIColor hx_colorWithHexRGBAString:@"#C91A25"]
                                               };
        } else {
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
    
    [GlobalService sharedInstance].normal_tabbar = self;
    self.selectedIndex = NORMAL_HOME_TABBAR_INDEX;
    [self.tabBar setHeight:50.f];
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

#pragma mark - RDVTabBarDelegate
- (BOOL)tabBar:(RDVTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index {
    if(index == NORMAL_SIGNUP_TABBAR_INDEX) {
        UINavigationController *signUpNC = self.viewControllers[NORMAL_SIGNUP_TABBAR_INDEX];
        if(signUpNC.viewControllers.count > 1) {
            [signUpNC popToRootViewControllerAnimated:NO];
        }
    } else if(index == NORMAL_LOGIN_TABBAR_INDEX) {
        UINavigationController *logInNC = self.viewControllers[NORMAL_LOGIN_TABBAR_INDEX];
        if(logInNC.viewControllers.count > 1) {
            [logInNC popToRootViewControllerAnimated:NO];
        }
    }
    
    return YES;
}

@end
