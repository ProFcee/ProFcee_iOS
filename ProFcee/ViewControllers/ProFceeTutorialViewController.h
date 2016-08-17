//
//  ProFceeTutorialViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/1/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProFceeTutorialViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIPageControl *m_ctlPage;
@property (weak, nonatomic) IBOutlet UIButton *m_btnSkip;

@property (weak, nonatomic) IBOutlet UIView *m_viewTrend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTrendText;

@property (weak, nonatomic) IBOutlet UIButton *m_btnProphecy;
@property (weak, nonatomic) IBOutlet UIButton *m_btnPost;
@property (weak, nonatomic) IBOutlet UIButton *m_btnMessage;

@property (strong, nonatomic) IBOutlet UIView *m_viewFirstTip;
@property (strong, nonatomic) IBOutlet UIView *m_viewSecondTip;
@property (strong, nonatomic) IBOutlet UIView *m_viewSecondTipPad;
@property (strong, nonatomic) IBOutlet UIView *m_viewThirdTip;
@property (strong, nonatomic) IBOutlet UIView *m_viewFourthTip;
@property (strong, nonatomic) IBOutlet UIView *m_viewFifthTip;

- (IBAction)onClickBtnSkip:(id)sender;

- (IBAction)onClickBtnFifthTip:(id)sender;
- (IBAction)onClickBtnFourthTip:(id)sender;
- (IBAction)onClickBtnThirdTip:(id)sender;
- (IBAction)onClickBtnSecondTip:(id)sender;
- (IBAction)onClickBtnFirstTip:(id)sender;

@end
