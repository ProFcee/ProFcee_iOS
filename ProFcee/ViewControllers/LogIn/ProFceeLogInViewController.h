//
//  ProFceeLogInViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTextField.h"
#import "ProFceeAuthenticateViewController.h"

@interface ProFceeLogInViewController : ProFceeAuthenticateViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet JHTextField *m_txtUserEmail;
@property (weak, nonatomic) IBOutlet JHTextField *m_txtUserPassword;

- (IBAction)onClickBtnLogIn:(id)sender;
- (IBAction)onClickBtnGoToSignUp:(id)sender;
- (IBAction)onClickBtnForgotPassword:(id)sender;

@end
