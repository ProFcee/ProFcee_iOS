//
//  ProFceeAgreesViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/4/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProFceeAgreesViewController : UIViewController {
    NSMutableArray      *m_aryUserStatus;
    NSArray             *m_aryAgrees;
}

@property (weak, nonatomic) IBOutlet UITableView    *m_tblAgrees;
@property (weak, nonatomic) IBOutlet UIButton       *m_btnSelectAll;
@property (weak, nonatomic) IBOutlet UITextView     *m_txtMessage;

@property (nonatomic, retain) ProFceeTrendObj       *m_selectedTrend;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnSend:(id)sender;
- (IBAction)onTapSelectAll:(id)sender;

@end
