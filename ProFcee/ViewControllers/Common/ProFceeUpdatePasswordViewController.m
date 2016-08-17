//
//  ProFceeUpdatePasswordViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeUpdatePasswordViewController.h"

@interface ProFceeUpdatePasswordViewController ()

@end

@implementation ProFceeUpdatePasswordViewController

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

- (IBAction)onClickBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnChangePassword:(id)sender {
    [self.m_txtCurrentPassword resignFirstResponder];
    [self.m_txtNewPassword resignFirstResponder];
    [self.m_txtConfirmPassword resignFirstResponder];
    
    if([self validateForm]) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] updatePasswordWithCurrentPassword:self.m_txtCurrentPassword.text
                                                           NewPassword:self.m_txtNewPassword.text
                                                             Completed:^(NSString *strResult, NSString *strError) {
                                                                 if(!strError) {
                                                                     SVPROGRESSHUD_SUCCESS(strResult);
                                                                 } else {
                                                                     SVPROGRESSHUD_ERROR(strError);
                                                                 }
                                                             }];
    }
}

- (BOOL)validateForm {
    BOOL isValid = NO;
    
    NSString *strCurrentPassword = [self.m_txtCurrentPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strNewPassword = [self.m_txtNewPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strConfirmPassword = [self.m_txtConfirmPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(strCurrentPassword.length < 6) {
        [self.view makeToast:TOAST_MESSAGE_SHORT_PASSWORD];
    } else if(strNewPassword.length < 6) {
        [self.view makeToast:TOAST_MESSAGE_SHORT_PASSWORD];
    } else if(![strNewPassword isEqualToString:strConfirmPassword]) {
        [self.view makeToast:TOAST_MESSAGE_DISMATCH_PASSWORD];
    } else {
        isValid = YES;
    }
    
    return isValid;
}

@end
