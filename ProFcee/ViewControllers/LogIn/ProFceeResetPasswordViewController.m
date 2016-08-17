//
//  ProFceeResetPasswordViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeResetPasswordViewController.h"
#import <SHEmailValidator/SHEmailValidator.h>

@interface ProFceeResetPasswordViewController ()

@end

@implementation ProFceeResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onClickBtnRestPassword:(id)sender {
    [self.m_txtConfirmationCode resignFirstResponder];
    [self.m_txtNewPassword resignFirstResponder];
    
    if(self.validateForm) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] resetPasswordWithCode:self.m_txtConfirmationCode.text
                                               NewPassword:self.m_txtNewPassword.text
                                                 Completed:^(NSString *strResult, NSString *strError) {
                                                     if(!strError) {
                                                         SVPROGRESSHUD_SUCCESS(strResult);
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     } else {
                                                         SVPROGRESSHUD_ERROR(strError);
                                                     }
                                                 }];
    }
}

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)validateForm {
    BOOL isValid = NO;
    
    NSString *strCode = self.m_txtConfirmationCode.text;
    NSString *strPassword = [self.m_txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(strCode.length == 0) {
        [self.view makeToast:TOAST_MESSAGE_NO_CODE];
    } else if(strPassword.length < 6) {
        [self.view makeToast:TOAST_MESSAGE_SHORT_PASSWORD];
    } else {
        isValid = YES;
    }
    
    return isValid;
}

@end
