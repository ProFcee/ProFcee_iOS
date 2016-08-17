//
//  ProFceeOtherProfileViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProFceeTrendViewController.h"

@interface ProFceeOtherProfileViewController : ProFceeTrendViewController

@property (weak, nonatomic) IBOutlet UILabel *m_lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgUserBanner;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgUserAvatar;

@property (nonatomic, retain) ProFceeUserObj     *m_selectedUser;

- (IBAction)onClickBtnBack:(id)sender;

@end
