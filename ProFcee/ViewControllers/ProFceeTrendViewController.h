//
//  ProFceeTrendViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/30/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DXPopover/DXPopover.h>
#import "ProFceeMorePopoverView.h"
#import "ProFceeTrendTableViewCell.h"
#import <AAShareBubbles/AAShareBubbles.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>

@interface ProFceeTrendViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, ProFceeMorePopoverViewDelegate, ProFceeTrendTableViewCellDelegate, UIAlertViewDelegate, AAShareBubblesDelegate, FBSDKSharingDelegate> {
    DXPopover           *m_viewPopover;
    ProFceeTrendInfoObj *m_objTrendInfo;
}

@property (weak, nonatomic) IBOutlet UILabel        *m_lblNotification;
@property (weak, nonatomic) IBOutlet UITableView    *m_tblTrend;

@property (nonatomic, retain) NSArray               *m_aryTrendInfos;

- (IBAction)onClickBtnSearch:(id)sender;
- (IBAction)onClickBtnMore:(id)sender;
- (IBAction)onClickBtnNotifications:(id)sender;

@end
