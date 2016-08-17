//
//  ProFceeSignUpViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeSignUpViewController.h"
#import <SHEmailValidator/SHEmailValidator.h>

@interface ProFceeSignUpViewController ()

@end

@implementation ProFceeSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[GlobalService sharedInstance].normal_tabbar setTabBarHidden:YES];
    
    // initialize form
    self.m_txtUserEmail.text = @"";
    self.m_txtUserName.text = @"";
    self.m_txtPassword.text = @"";
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

- (IBAction)onClickBtnSignUp:(id)sender {
    [self.m_txtUserEmail resignFirstResponder];
    [self.m_txtUserName resignFirstResponder];
    [self.m_txtPassword resignFirstResponder];
    
    if([self validateSignUp]) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] signUpUserWithEmail:self.m_txtUserEmail.text
                                                UserName:self.m_txtUserName.text
                                                Password:self.m_txtPassword.text
                                               Completed:^(ProFceeUserMe *objMe, NSString *strError) {
                                                   if(!strError) {
                                                       SVPROGRESSHUD_DISMISS;
                                                       [GlobalService sharedInstance].user_me = objMe;
                                                       [[GlobalService sharedInstance] saveMe];
    
                                                       UIViewController *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeLocationViewController"];
                                                       [self.navigationController pushViewController:locationVC animated:YES];
                                                   } else {
                                                       SVPROGRESSHUD_ERROR(strError);
                                                   }
                                               }];
    }
}

- (BOOL)validateSignUp {
    BOOL isValid = NO;
    
    NSString *strEmail = self.m_txtUserEmail.text;
    NSString *strUserName = self.m_txtUserName.text;
    NSString *strPassword = [self.m_txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSError *error = nil;
    if(![[SHEmailValidator validator] validateSyntaxOfEmailAddress:strEmail withError:&error]) {
        [self.view makeToast:TOAST_MESSAGE_INVALID_EMAIL];
    } else if(strUserName.length == 0) {
        [self.view makeToast:TOAST_MESSAGE_NO_USERNAME];
    } else if(strPassword.length < 6) {
        [self.view makeToast:TOAST_MESSAGE_SHORT_PASSWORD];
    } else {
        isValid = YES;
    }
    
    return isValid;
}

- (IBAction)onClickBtnGoToLogIn:(id)sender {
    [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_LOGIN_TABBAR_INDEX;
}

@end
