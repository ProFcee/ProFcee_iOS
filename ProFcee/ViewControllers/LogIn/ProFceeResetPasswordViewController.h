//
//  ProFceeResetPasswordViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTextField.h"

@interface ProFceeResetPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet JHTextField *m_txtConfirmationCode;
@property (weak, nonatomic) IBOutlet JHTextField *m_txtNewPassword;

- (IBAction)onClickBtnRestPassword:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;

@end
