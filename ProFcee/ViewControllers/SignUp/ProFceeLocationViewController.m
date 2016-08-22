//
//  ProFceeLocationViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/30/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeLocationViewController.h"
#import "ProFceeLocationTableViewCell.h"
#import "ProFceeLocationSelectViewController.h"

@interface ProFceeLocationViewController ()

@end

@implementation ProFceeLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.m_imgAvatar setImageWithUrl:[GlobalService sharedInstance].user_me.my_user.avatarUrl
                      withPlaceholder:@"me_image_avatar"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGotLocation) name:USER_NOTIFICATION_GOT_LOCATION object:nil];
    
    if([GlobalService sharedInstance].user_city.city_id.intValue == 0) {
        SVPROGRESSHUD_PLEASE_WAIT;
    }
    
    self.m_tblLocation.rowHeight = UITableViewAutomaticDimension;
    self.m_tblLocation.estimatedRowHeight = 44.0f;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.m_imgAvatar.layer.masksToBounds = YES;
    self.m_imgAvatar.layer.cornerRadius = CGRectGetWidth(self.m_imgAvatar.frame) / 2.f;
}

- (void)onGotLocation {
    SVPROGRESSHUD_DISMISS;
    [self.m_tblLocation reloadData];
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

- (IBAction)onTapBannerView:(id)sender {
    m_hasBanner = YES;
    [self showActionSheet];
}

- (IBAction)onTapAvatarView:(id)sender {
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
    UIAlertAction *btnCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          m_hasAvatar = NO;
                                                          m_hasBanner = NO;
                                                      }];
    
    [sheet addAction:btnCamera];
    [sheet addAction:btnPhotoGallery];
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
            cropVC.aspectRatioLockEnabled = YES;
            cropVC.resetAspectRatioEnabled = NO;
        }
        
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
            self.m_imgAvatar.image = image;
        } else {
            self.m_imgBanner.image = image;
        }
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        m_hasAvatar = NO;
        m_hasBanner = NO;
    }];
}

- (IBAction)onclickBtnGetMe:(id)sender {    
    [GlobalService sharedInstance].user_me.my_user.user_city_id = [GlobalService sharedInstance].user_city.city_id;
    [GlobalService sharedInstance].user_me.my_user.user_city = [GlobalService sharedInstance].user_city.city_name;
    
    SVPROGRESSHUD_PLEASE_WAIT;
    [[WebService sharedInstance] updateUserWithUserObj:[GlobalService sharedInstance].user_me.my_user
                                          ProfileImage:m_hasAvatar ? self.m_imgAvatar.image : nil
                                           BannerImage:m_hasBanner ? self.m_imgBanner.image : nil
                                              Progress:^(double progress) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      SVPROGRESSHUD_PROGRESS(progress);
                                                  });
                                              }
                                             Completed:^(ProFceeUserObj *objUser, NSString *strError) {
                                                 if(!strError) {
                                                     SVPROGRESSHUD_DISMISS;
                                                     [GlobalService sharedInstance].user_me.my_user = objUser;
                                                     [GlobalService sharedInstance].user_me.my_city = [GlobalService sharedInstance].user_city;
                                                     [[GlobalService sharedInstance] saveMe];
                                                     
                                                     if([[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_KEY_FIRST_USER]) {
                                                         [GlobalService sharedInstance].normal_tabbar.selectedIndex = NORMAL_HOME_TABBAR_INDEX;
                                                         [[GlobalService sharedInstance].app_delegate startApplication];
                                                     } else {
                                                         [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULTS_KEY_FIRST_USER];
                                                         [[NSUserDefaults standardUserDefaults] synchronize];
                                                         
                                                         UIViewController *tutorialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProFceeTutorialViewController"];
                                                         [self presentViewController:tutorialVC animated:NO completion:nil];
                                                     }
                                                 } else {
                                                     SVPROGRESSHUD_ERROR(strError);
                                                 }
                                             }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProFceeLocationTableViewCell class])];
    
    if(indexPath.row == 0) {
        cell.m_lblTitle.text = @"Country";
        cell.m_lblContent.text = [GlobalService sharedInstance].user_city.city_state.state_country.country_name;
    } else if(indexPath.row == 1) {
        cell.m_lblTitle.text = @"State";
        cell.m_lblContent.text = [GlobalService sharedInstance].user_city.city_state.state_name;
    } else {
        cell.m_lblTitle.text = @"City";
        cell.m_lblContent.text = [GlobalService sharedInstance].user_city.city_name;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProFceeLocationSelectViewController *locationSelectVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProFceeLocationSelectViewController class])];
    locationSelectVC.m_typeLocation = (LOCATION_TYPE)indexPath.row;
    [self.navigationController pushViewController:locationSelectVC animated:YES];
}

@end
