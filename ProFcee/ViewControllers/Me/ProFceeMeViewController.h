//
//  ProFceeMeViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProFceeTrendViewController.h"

@interface ProFceeMeViewController : ProFceeTrendViewController<UIAlertViewDelegate> {
    NSMutableArray  *m_aryMyTrends;
    NSArray         *m_aryMyAgreedTrends;
}

@property (weak, nonatomic) IBOutlet UIImageView        *m_imgUserBanner;
@property (weak, nonatomic) IBOutlet UIImageView        *m_imgUserAvatar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *m_segTrend;

- (IBAction)onClickBtnEditProfile:(id)sender;
- (IBAction)onClickBtnLogOut:(id)sender;
- (IBAction)onSwitchSegment:(id)sender;

@end
