//
//  ProFceeEditProfileViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeEditProfileViewController.h"
#import "ProFceeProfileInputTableViewCell.h"
#import "ProFceeProfileSelectTableViewCell.h"
#import "ProFceeLocationSelectViewController.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>

@interface ProFceeEditProfileViewController ()

@end

@implementation ProFceeEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.m_imgUserBanner setImageWithUrl:[GlobalService sharedInstance].user_me.my_user.bannerUrl
                          withPlaceholder:nil];
    
    m_tmpUserObj = [[ProFceeUserObj alloc] initWithDictionary:[GlobalService sharedInstance].user_me.my_user.currentDictionary];
    
    self.m_tblProfile.rowHeight = UITableViewAutomaticDimension;
    self.m_tblProfile.estimatedRowHeight = 44.0f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGotLocation) name:USER_NOTIFICATION_GOT_LOCATION object:nil];
}

- (void)onGotLocation {
    [self.m_tblProfile reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.m_imgUserAvatar.layer.masksToBounds = YES;
    self.m_imgUserAvatar.layer.cornerRadius = CGRectGetHeight(self.m_imgUserAvatar.frame) / 2.f;
    [self.m_imgUserAvatar setImageWithUrl:[GlobalService sharedInstance].user_me.my_user.avatarUrl
                          withPlaceholder:nil];
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

- (IBAction)onClickBtnSave:(id)sender {
    m_tmpUserObj.user_city_id = [GlobalService sharedInstance].user_city.city_id;
    m_tmpUserObj.user_city = [GlobalService sharedInstance].user_city.city_name;
    
    // get user information
    ProFceeProfileInputTableViewCell *cell = [self.m_tblProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    m_tmpUserObj.user_name = cell.m_txtValue.text;
    if(m_tmpUserObj.user_name.length == 0) {
        [self.view makeToast:TOAST_MESSAGE_NO_USERNAME duration:2.f position:CSToastPositionCenter];
        return;
    }
    
    cell = [self.m_tblProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    m_tmpUserObj.user_organisation = cell.m_txtValue.text;
    
    cell = [self.m_tblProfile cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    m_tmpUserObj.user_designation = cell.m_txtValue.text;
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] updateUserWithUserObj:m_tmpUserObj
                                          ProfileImage:m_hasAvatar ? self.m_imgUserAvatar.image : nil
                                           BannerImage:m_hasBanner ? self.m_imgUserBanner.image : nil
                                              Progress:^(double progress) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      SVPROGRESSHUD_PROGRESS(progress);
                                                  });
                                              }
                                             Completed:^(ProFceeUserObj *objUser, NSString *strError) {
                                                 if(!strError) {
                                                     SVPROGRESSHUD_SUCCESS(@"Profile updated successfully");
                                                     m_tmpUserObj = [[ProFceeUserObj alloc] initWithDictionary:objUser.currentDictionary];
                                                     
                                                     [GlobalService sharedInstance].user_me.my_user = objUser;
                                                     [GlobalService sharedInstance].user_me.my_city = [GlobalService sharedInstance].user_city;
                                                     [[GlobalService sharedInstance] saveMe];
                                                 } else {
                                                     SVPROGRESSHUD_ERROR(strError);
                                                 }
                                             }];
}

- (IBAction)onTapBannerImage:(id)sender {
    m_hasBanner = YES;
    [self showActionSheet];
}

- (IBAction)onTapAvatarImage:(id)sender {
    m_hasAvatar = YES;
    [self showActionSheet];
}

- (void)showActionSheet {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Choose image from..."
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *btnCamera = [UIAlertAction actionWithTitle:@"Camera"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                              UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                                              imagePicker.delegate = self;
                                                              imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                              imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
                                                              imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
                                                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                  [self presentViewController:imagePicker animated:YES completion:nil];
                                                              }];
                                                          }
                                                      }];
    UIAlertAction *btnPhotoGallery = [UIAlertAction actionWithTitle:@"Photo Gallery"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                                                    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                                                                    imagePicker.delegate = self;
                                                                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                                        [self presentViewController:imagePicker animated:YES completion:nil];
                                                                    }];
                                                                }
                                                            }];
    
    [sheet addAction:btnCamera];
    [sheet addAction:btnPhotoGallery];
    
    if(m_hasAvatar && m_tmpUserObj.user_profile_image.length > 0) {
            UIAlertAction *btnDelete = [UIAlertAction actionWithTitle:@"Delete Avatar"
                                                                style:UIAlertActionStyleDestructive
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  NSString *strDefaultAvatar = [NSString stringWithFormat:@"%@%@", [WebService sharedInstance].m_strProfceeDomain, @"/assets/avatar/default.jpg"];
                                                                  m_tmpUserObj.user_profile_image = @"";
                                                                  [self.m_imgUserAvatar setImageWithUrl:strDefaultAvatar
                                                                                        withPlaceholder:nil];
                                                                  m_hasAvatar = NO;
                                                              }];
        [sheet addAction:btnDelete];
    }
    
    if(m_hasBanner && m_tmpUserObj.user_banner_image.length > 0) {
        UIAlertAction *btnDelete = [UIAlertAction actionWithTitle:@"Delete Banner"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSString *strDefaltBanner = [NSString stringWithFormat:@"%@%@", [WebService sharedInstance].m_strProfceeDomain, @"/assets/banner/default.jpg"];
                                                              m_tmpUserObj.user_banner_image = @"";
                                                              [self.m_imgUserBanner setImageWithUrl:strDefaltBanner
                                                                                    withPlaceholder:nil];
                                                              m_hasBanner = NO;
                                                          }];
        [sheet addAction:btnDelete];
    }
    
    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          m_hasAvatar = NO;
                                                          m_hasBanner = NO;
                                                      }];
    
    [sheet addAction:btnCancel];
    
    UIPopoverPresentationController *popPresenter = [sheet popoverPresentationController];
    popPresenter.sourceView = self.view;
    popPresenter.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height, 1.0, 1.0);
    
    [self presentViewController:sheet animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *imgPicker = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:NO completion:^{
        TOCropViewController *cropVC = [[TOCropViewController alloc] initWithImage:imgPicker];
        cropVC.delegate = self;
        if(m_hasAvatar) {
            cropVC.aspectRatioPreset = TOCropViewControllerAspectRatioPresetSquare;
        } else {
            cropVC.aspectRatioPreset = TOCropViewControllerAspectRatioPresetCustom;
            cropVC.customAspectRatio = CGSizeMake(8.f, 3.f);
        }
        
        cropVC.aspectRatioLockEnabled = YES;
        cropVC.resetAspectRatioEnabled = NO;
        
        [self presentViewController:cropVC animated:NO completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        m_hasBanner = NO;
        m_hasAvatar = NO;
    }];
}

#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        if(m_hasAvatar) {
            self.m_imgUserAvatar.image = image;
        } else {
            self.m_imgUserBanner.image = image;
        }
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        m_hasAvatar = NO;
        m_hasBanner = NO;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2) {
        return 2;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        ProFceeProfileInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProFceeProfileInputTableViewCell class])];
        
        if(indexPath.row == 0) {
            cell.m_lblTitle.text = @"Your full name";
            cell.m_txtValue.text = m_tmpUserObj.user_name;
        } else if(indexPath.row == 1) {
            cell.m_lblTitle.text = @"Organisation";
            cell.m_txtValue.text = m_tmpUserObj.user_organisation;
        } else {
            cell.m_lblTitle.text = @"Designation";
            cell.m_txtValue.text = m_tmpUserObj.user_designation;
        }
        
        return cell;
    } if(indexPath.section == 1) {
        ProFceeProfileSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProFceeProfileSelectTableViewCell class])];
        
        if(indexPath.row == 0) {
            cell.m_lblTitle.text = @"Country";
            cell.m_lblValue.text = [GlobalService sharedInstance].user_city.city_state.state_country.country_name;
        } else if(indexPath.row == 1) {
            cell.m_lblTitle.text = @"State";
            cell.m_lblValue.text = [GlobalService sharedInstance].user_city.city_state.state_name;
        } else if(indexPath.row == 2) {
            cell.m_lblTitle.text = @"City";
            cell.m_lblValue.text = [GlobalService sharedInstance].user_city.city_name;
        }
        
        return cell;
    } else {
        ProFceeProfileSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProFceeProfileSelectTableViewCell class])];
        
        if(indexPath.row == 0) {
            cell.m_lblTitle.text = @"Date of birth";
            cell.m_lblValue.text = [[GlobalService sharedInstance] stringFromDate:m_tmpUserObj.user_dob
                                                                       withFormat:@"MM/dd/yyyy"];
        } else {
            cell.m_lblTitle.text = @"Gender";
            cell.m_lblValue.text = m_tmpUserObj.user_gender;
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProFceeProfileSelectTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == 1) {
        ProFceeLocationSelectViewController *locationSelectVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProFceeLocationSelectViewController class])];
        locationSelectVC.m_typeLocation = (LOCATION_TYPE)indexPath.row;
        [self.navigationController pushViewController:locationSelectVC animated:YES];
    } else if(indexPath.section == 2) {
        if(indexPath.row == 0) {     //Dob
            [ActionSheetDatePicker showPickerWithTitle:@"Choose your birthday"
                                        datePickerMode:UIDatePickerModeDate
                                          selectedDate:[GlobalService sharedInstance].user_me.my_user.user_dob
                                             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                 m_tmpUserObj.user_dob = selectedDate;
                                                 cell.m_lblValue.text = [[GlobalService sharedInstance] stringFromDate:selectedDate
                                                                                                            withFormat:@"MM/dd/yyyy"];
                                             }
                                           cancelBlock:nil
                                                origin:cell];
        } else {    //Gender
            NSArray *aryGenders = @[@"Male", @"Female"];
            [ActionSheetStringPicker showPickerWithTitle:@"Choose your gender"
                                                    rows:aryGenders
                                        initialSelection:[aryGenders indexOfObject:m_tmpUserObj.user_gender]
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   m_tmpUserObj.user_gender = selectedValue;
                                                   cell.m_lblValue.text = selectedValue;
                                               }
                                             cancelBlock:nil
                                                  origin:cell];
        }
    }
}

@end
