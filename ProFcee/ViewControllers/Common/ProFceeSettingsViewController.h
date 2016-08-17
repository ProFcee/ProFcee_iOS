//
//  ProFceeSettingsViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProFceeSettingsTableViewCell.h"

@interface ProFceeSettingsViewController : UIViewController<ProFceeSettingsTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *m_tblSettings;

- (IBAction)onClickBtnBack:(id)sender;

@end
