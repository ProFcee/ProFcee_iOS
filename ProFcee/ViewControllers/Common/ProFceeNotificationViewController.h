//
//  ProFceeNotificationViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProFceeNotificationTableViewCell.h"

@interface ProFceeNotificationViewController : UIViewController<ProFceeNotificationTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *m_tblNotification;

- (IBAction)onClickBtnClearAll:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;

@end
