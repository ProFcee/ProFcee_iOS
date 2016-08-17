//
//  ProFceeTutorialViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/1/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeTutorialViewController.h"
#import <TrAnimate/TrAnimate.h>

#define TREND_USER_VIEW_HEIGHT          40
#define TREND_ACTION_VIEW_HEIGHT        45

@interface ProFceeTutorialViewController ()

@end

@implementation ProFceeTutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.m_constraintViewHeight.constant = (CGRectGetWidth(self.view.frame) - 20) * TREND_IMAGE_RATIO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showFirstTutorialTip];
    });
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

- (IBAction)onClickBtnSkip:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
       [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_HOME_TABBAR_INDEX;
       [[GlobalService sharedInstance].app_delegate startApplication];
    }];
}

- (void)showFifthTutorialTip {
    self.m_ctlPage.currentPage = 4;
    self.m_btnMessage.hidden = NO;
    
    [self.view addSubview:self.m_viewFifthTip];
    CGRect frame = self.m_viewFifthTip.frame;
    frame.origin.x = CGRectGetWidth(self.view.frame) * 7.f / 10.f - CGRectGetWidth(self.m_viewFifthTip.frame) / 2.f;
    frame.origin.y = CGRectGetHeight(self.view.frame) - 60.f - CGRectGetHeight(self.m_viewFifthTip.frame);
    self.m_viewFifthTip.frame = frame;
    
    [TrFadeAnimation animate:self.m_viewFifthTip
                    duration:1.f
                       delay:0.f
                   direction:TrFadeAnimationDirectionIn];
}

- (IBAction)onClickBtnFifthTip:(id)sender {
    [TrScaleAnimation animate:self.m_viewFifthTip
                     duration:0.3f
                        delay:0.f
              fromScaleFactor:1.f
                toScaleFactor:0.f
                        curve:nil
                   completion:^(BOOL finished) {
                       [self.m_viewFifthTip removeFromSuperview];
                       [self onClickBtnSkip:nil];
                   }];
}

- (void)showFourthTutorialTip {
    self.m_ctlPage.currentPage = 3;
    self.m_btnPost.hidden = NO;
    
    [self.view addSubview:self.m_viewFourthTip];
    CGRect frame = self.m_viewFourthTip.frame;
    frame.origin.x = CGRectGetWidth(self.view.frame) / 2.f - CGRectGetWidth(self.m_viewFourthTip.frame) / 2.f;
    frame.origin.y = CGRectGetHeight(self.view.frame) - 60.f - CGRectGetHeight(self.m_viewFourthTip.frame);
    self.m_viewFourthTip.frame = frame;
    
    [TrFadeAnimation animate:self.m_viewFourthTip
                    duration:1.f
                       delay:0.f
                   direction:TrFadeAnimationDirectionIn];
}

- (IBAction)onClickBtnFourthTip:(id)sender {
    [TrScaleAnimation animate:self.m_viewFourthTip
                     duration:0.3f
                        delay:0.f
              fromScaleFactor:1.f
                toScaleFactor:0.f
                        curve:nil
                   completion:^(BOOL finished) {
                       [self.m_viewFourthTip removeFromSuperview];
                       [self showFifthTutorialTip];
                   }];
}

- (void)showThirdTutorialTip {
    self.m_ctlPage.currentPage = 2;
    self.m_btnProphecy.hidden = NO;
    
    [self.view addSubview:self.m_viewThirdTip];
    CGRect frame = self.m_viewThirdTip.frame;
    frame.origin.x = CGRectGetWidth(self.view.frame) * 3.f / 10.f - 90.f;
    frame.origin.y = CGRectGetHeight(self.view.frame) - 60.f - CGRectGetHeight(self.m_viewThirdTip.frame);
    
    if(frame.origin.x * 2 + frame.size.width > CGRectGetWidth(self.view.frame)) {
        frame.size.width = CGRectGetWidth(self.view.frame) - frame.origin.x * 2;
    }
    
    self.m_viewThirdTip.frame = frame;
    
    [TrFadeAnimation animate:self.m_viewThirdTip
                    duration:1.f
                       delay:0.f
                   direction:TrFadeAnimationDirectionIn];
}

- (IBAction)onClickBtnThirdTip:(id)sender {
    [TrScaleAnimation animate:self.m_viewThirdTip
                     duration:0.3f
                        delay:0.f
              fromScaleFactor:1.f
                toScaleFactor:0.f
                        curve:nil
                   completion:^(BOOL finished) {
                       [self.m_viewThirdTip removeFromSuperview];
                       [self showFourthTutorialTip];
                   }];
}

- (void)showSecondTutorialTip {
    self.m_ctlPage.currentPage = 1;
    
    UIView *viewSecond = IS_IPHONE ? self.m_viewSecondTip : self.m_viewSecondTipPad;
    
    [self.view addSubview:viewSecond];
    CGRect frame = viewSecond.frame;
    frame.origin.x = CGRectGetWidth(self.view.frame) / 2.f - CGRectGetWidth(viewSecond.frame);
    frame.origin.y = CGRectGetHeight(self.m_viewTrend.frame) + 64.f + 20.f;

    if(frame.origin.x < 0) {
        frame.origin.x = 10.f;
    }
    viewSecond.frame = frame;
    
    [TrFadeAnimation animate:viewSecond
                    duration:1.f
                       delay:0.f
                   direction:TrFadeAnimationDirectionIn];
}

- (IBAction)onClickBtnSecondTip:(id)sender {
    UIView *viewSecond = IS_IPHONE ? self.m_viewSecondTip : self.m_viewSecondTipPad;
    
    [TrScaleAnimation animate:viewSecond
                     duration:0.3f
                        delay:0.f
              fromScaleFactor:1.f
                toScaleFactor:0.f
                        curve:nil
                   completion:^(BOOL finished) {
                       [viewSecond removeFromSuperview];
                       [self showThirdTutorialTip];
                   }];
}

- (void)showFirstTutorialTip {
    [self.view addSubview:self.m_viewFirstTip];
    CGRect frame = self.m_viewFirstTip.frame;
    frame.origin.x = CGRectGetWidth(self.view.frame) / 2.f - CGRectGetWidth(self.m_viewFirstTip.frame) / 2.f;
    frame.origin.y = CGRectGetHeight(self.m_viewTrend.frame) + 64.f - TREND_ACTION_VIEW_HEIGHT + 20.f;
    self.m_viewFirstTip.frame = frame;
    
    [TrFadeAnimation animate:self.m_viewFirstTip
                    duration:1.f
                       delay:0.f
                   direction:TrFadeAnimationDirectionIn];
}

- (IBAction)onClickBtnFirstTip:(id)sender {
    [TrScaleAnimation animate:self.m_viewFirstTip
                     duration:0.3f
                        delay:0.f
              fromScaleFactor:1.f
                toScaleFactor:0.f
                        curve:nil
                   completion:^(BOOL finished) {
                       [self.m_viewFirstTip removeFromSuperview];
                       [self showSecondTutorialTip];
                   }];
}

@end
