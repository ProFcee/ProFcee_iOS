//
//  ProFceeAuthenticateViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/28/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <ResponsiveLabel/ResponsiveLabel.h>

@interface ProFceeAuthenticateViewController : UIViewController<GIDSignInDelegate, GIDSignInUIDelegate>

@property (weak, nonatomic) IBOutlet ResponsiveLabel *m_lblTerms;

- (IBAction)onClickBtnFacebookLogIn:(id)sender;
- (IBAction)onClickBtnTwitterLogIn:(id)sender;
- (IBAction)onClickBtnGoogleLogIn:(id)sender;
- (IBAction)onClickBtnBack:(id)sender;

@end
