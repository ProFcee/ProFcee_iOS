//
//  ProFceeLocationViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/30/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TOCropViewController/TOCropViewController.h>

@interface ProFceeLocationViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate> {
    BOOL        m_hasAvatar;
    BOOL        m_hasBanner;
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgBanner;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgAvatar;
@property (weak, nonatomic) IBOutlet UITableView *m_tblLocation;

- (IBAction)onTapBannerView:(id)sender;
- (IBAction)onTapAvatarView:(id)sender;
- (IBAction)onclickBtnGetMe:(id)sender;

@end
