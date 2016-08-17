//
//  ProFceeLogInViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeLogInViewController.h"
#import <SHEmailValidator/SHEmailValidator.h>

@interface ProFceeLogInViewController ()

@end

@implementation ProFceeLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[GlobalService sharedInstance].normal_tabbar setTabBarHidden:YES];
    
    // initialize form
    self.m_txtUserEmail.text = @"";
    self.m_txtUserPassword.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickBtnLogIn:(id)sender {
    [self.m_txtUserEmail resignFirstResponder];
    [self.m_txtUserPassword resignFirstResponder];
    
    if(self.validateLogIn) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] loginUserWithEmail:self.m_txtUserEmail.text
                                               Password:self.m_txtUserPassword.text
                                              Completed:^(ProFceeUserMe *objMe, NSString *strError) {
                                                  if(strError) {
                                                      SVPROGRESSHUD_ERROR(strError);
                                                  } else {
                                                      SVPROGRESSHUD_DISMISS;
                                                      [GlobalService sharedInstance].user_me = objMe;
                                                      [[GlobalService sharedInstance] saveMe];
                                                      
                                                      [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_HOME_TABBAR_INDEX;
                                                      [[GlobalService sharedInstance].app_delegate startApplication];
                                                  }
                                              }];
    }
}

- (BOOL)validateLogIn {
    BOOL isValid = NO;
    
    NSString *strEmail = self.m_txtUserEmail.text;
    NSString *strPassword = [self.m_txtUserPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSError *error = nil;
    if(![[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
        [self.view makeToast:TOAST_MESSAGE_INVALID_EMAIL];
    } else if(strPassword.length < 6) {
        [self.view makeToast:TOAST_MESSAGE_SHORT_PASSWORD];
    } else {
        isValid = YES;
    }
    
    return isValid;
}

- (IBAction)onClickBtnGoToSignUp:(id)sender {
    [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_SIGNUP_TABBAR_INDEX;
}

- (IBAction)onClickBtnForgotPassword:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter your email"
                                                    message:@"we will send a code to reset the password"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Send", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UIAelrtViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        NSString *strEmail = [alertView textFieldAtIndex:0].text;
        NSError *error;
        
        if(![[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
            [self.view makeToast:TOAST_MESSAGE_INVALID_EMAIL];
        } else {
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] forgotPasswordWithEmail:strEmail
                                                       Completed:^(NSString *strResult, NSString *strError) {
                                                           if(!strError) {
                                                               SVPROGRESSHUD_SUCCESS(strResult);
                                                               
                                                               UIViewController *resetPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeResetPasswordViewController"];
                                                               [self.navigationController pushViewController:resetPasswordVC animated:YES];
                                                           } else {
                                                               SVPROGRESSHUD_ERROR(strResult);
                                                           }
                                                       }];
        }
    }
}

@end
