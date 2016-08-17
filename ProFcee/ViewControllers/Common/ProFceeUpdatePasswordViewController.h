//
//  ProFceeUpdatePasswordViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTextField.h"

@interface ProFceeUpdatePasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet JHTextField *m_txtCurrentPassword;
@property (weak, nonatomic) IBOutlet JHTextField *m_txtNewPassword;
@property (weak, nonatomic) IBOutlet JHTextField *m_txtConfirmPassword;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnChangePassword:(id)sender;

@end
