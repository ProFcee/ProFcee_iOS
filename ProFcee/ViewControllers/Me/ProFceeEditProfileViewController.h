//
//  ProFceeEditProfileViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TOCropViewController/TOCropViewController.h>

@interface ProFceeEditProfileViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate, UITextFieldDelegate> {
    BOOL            m_hasAvatar;
    BOOL            m_hasBanner;
    
    ProFceeUserObj  *m_tmpUserObj;
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgUserBanner;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgUserAvatar;
@property (weak, nonatomic) IBOutlet UITableView *m_tblProfile;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onClickBtnSave:(id)sender;
- (IBAction)onTapBannerImage:(id)sender;
- (IBAction)onTapAvatarImage:(id)sender;

@end
