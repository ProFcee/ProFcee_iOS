//
//  ProFceeSignUpViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTextField.h"
#import "ProFceeAuthenticateViewController.h"

@interface ProFceeSignUpViewController : ProFceeAuthenticateViewController

@property (weak, nonatomic) IBOutlet JHTextField *m_txtUserEmail;
@property (weak, nonatomic) IBOutlet JHTextField *m_txtUserName;
@property (weak, nonatomic) IBOutlet JHTextField *m_txtPassword;

- (IBAction)onClickBtnSignUp:(id)sender;
- (IBAction)onClickBtnGoToLogIn:(id)sender;

@end
