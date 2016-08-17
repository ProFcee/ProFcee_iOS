//
//  ProfceeAuthenticateViewController.m
//  Profcee
//
//  Created by Dealyourself Internet Private Limited on 7/28/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeAuthenticateViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>

@interface ProFceeAuthenticateViewController ()

@end

@implementation ProFceeAuthenticateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PatternTapResponder tapResponder = ^(NSString *string) {
        if([string isEqualToString:@"Terms of service"]) {
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:PROFCEE_TERMS_URL]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PROFCEE_TERMS_URL]];
            }
        } else {
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:PROFCEE_PRIVACY_URL]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PROFCEE_PRIVACY_URL]];
            }
        }
    };
    
    [self.m_lblTerms enableDetectionForStrings:@[@"Terms of service", @"Privacy policy"]
                                withAttributes:@{
                                                 RLTapResponderAttributeName:       tapResponder,
                                                 NSForegroundColorAttributeName:    [UIColor hx_colorWithHexRGBAString:@"#C91A25"]
                                                 }];
    
    self.m_lblTerms.font = IS_IPHONE ? [UIFont fontWithName:@".SFUIText-Regular" size:14.f] : [UIFont fontWithName:@".SFUIText-Regular" size:19.f];
    
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].clientID = @"861359448109-526ccpr63a8vktph8spbb7e83bht5age.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].scopes = @[@"https://www.googleapis.com/auth/plus.login", @"https://www.googleapis.com/auth/plus.me"];
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

- (IBAction)onClickBtnFacebookLogIn:(id)sender {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile", @"user_friends", @"email"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                [self getResultFromFBSKD:result error:error];
                            }];
}

- (void)getResultFromFBSKD:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        // Process error
        NSLog(@"%@", error.localizedDescription);
    } else if (result.isCancelled) {
        // Handle cancellations
        
    } else {
        // If you ask for multiple permissions at once, you
        // should check if specific permissions missing
        if ([result.grantedPermissions containsObject:@"email"]) {
            // Do work
            if ([FBSDKAccessToken currentAccessToken]) {
                SVPROGRESSHUD_PLEASE_WAIT;
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id user, NSError *error) {
                     if (!error) {
                         NSLog(@"fetched user:%@", user);
                         
                         NSString *user_email = user[@"email"];
                         NSString *user_id = user[@"id"];
                         
                         [self socialLoginWithEmail:user_email.length > 0 ? user_email : user_id
                                               Name:user[@"name"]
                                                 ID:user_id
                                           ImageUrl:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", user_id]];
                     } else {
                         SVPROGRESSHUD_ERROR(error.localizedDescription);
                     }
                 }];
            }
        }
    }
}

- (IBAction)onClickBtnTwitterLogIn:(id)sender {
    [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBased completion:^(TWTRSession *session, NSError *error) {
        if(!error) {
            SVPROGRESSHUD_PLEASE_WAIT;
            TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
            NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                             URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
                                                      parameters:@{@"include_email": @"true", @"skip_status": @"true"}
                                                           error:nil];
            
            [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if(!connectionError) {
                    NSDictionary *dicUser = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    [self socialLoginWithEmail:[dicUser[@"email"] length] > 0 ? dicUser[@"email"] : dicUser[@"id_str"]
                                          Name:dicUser[@"name"]
                                            ID:dicUser[@"id_str"]
                                      ImageUrl:dicUser[@"profile_image_url"]];
                } else {
                    SVPROGRESSHUD_ERROR(connectionError.localizedDescription);
                }
            }];
        }
    }];
}

- (IBAction)onClickBtnGoogleLogIn:(id)sender {
    [[GIDSignIn sharedInstance] signIn];
}

#pragma mark - GIDSignInDelegate
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    if(error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        SVPROGRESSHUD_PLEASE_WAIT;
        [self socialLoginWithEmail:user.profile.email.length > 0 ? user.profile.email : user.userID
                              Name:user.profile.name
                                ID:user.userID
                          ImageUrl:[[user.profile imageURLWithDimension:320] absoluteString]];
    }
}

- (void)socialLoginWithEmail:(NSString *)email
                        Name:(NSString *)name
                          ID:(NSString *)user_id
                    ImageUrl:(NSString *)image_url {
    [[WebService sharedInstance] socialLoginWithEmail:email
                                                 Name:name
                                             Password:user_id
                                         ProfileImage:image_url
                                            Completed:^(ProFceeUserMe *objMe, NSString *strError) {
                                                if(!strError) {
                                                    SVPROGRESSHUD_DISMISS;
                                                    [GlobalService sharedInstance].user_me = objMe;
                                                    [[GlobalService sharedInstance] saveMe];
                                                    
                                                    //check it's login or signup
                                                    if(objMe.my_city.city_id.intValue == 0) {  //signup
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            UIViewController *locationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeLocationViewController"];
                                                            [self.navigationController pushViewController:locationVC animated:YES];
                                                        });
                                                    } else {
                                                        [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_HOME_TABBAR_INDEX;
                                                        [[GlobalService sharedInstance].app_delegate startApplication];
                                                    }
                                                } else {
                                                    SVPROGRESSHUD_ERROR(strError);
                                                }
                                            }];
}

- (IBAction)onClickBtnBack:(id)sender {
    [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_HOME_TABBAR_INDEX;
}

@end
