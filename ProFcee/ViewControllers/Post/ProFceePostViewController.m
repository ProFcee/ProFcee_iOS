//
//  ProFceePostViewController.m
//  Profcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceePostViewController.h"

@interface ProFceePostViewController ()

@end

@implementation ProFceePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[GlobalService sharedInstance].user_tabbar setTabBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([GlobalService sharedInstance].user_me.my_settings.settings_suggest_typing){
        [self.m_txtTrendBody setAutocorrectionType:UITextAutocorrectionTypeYes];
    } else {
        [self.m_txtTrendBody setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    
    if([GlobalService sharedInstance].user_me.my_settings.settings_spell_typing){
        [self.m_txtTrendBody setSpellCheckingType:UITextSpellCheckingTypeYes];
    } else {
        [self.m_txtTrendBody setSpellCheckingType:UITextSpellCheckingTypeNo];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[GlobalService sharedInstance].user_tabbar setTabBarHidden:YES];
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
    [GlobalService sharedInstance].user_tabbar.selectedIndex = USER_HOME_TABBAR_INDEX;
}

- (IBAction)onTapTrendImage:(id)sender {
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
                                                      handler:nil];
    
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
        cropVC.aspectRatioPreset = TOCropViewControllerAspectRatioPreset16x9;
        cropVC.aspectRatioLockEnabled = YES;
        cropVC.resetAspectRatioEnabled = NO;
        cropVC.delegate = self;
        [self presentViewController:cropVC animated:NO completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TOCropViewControllerDelegate
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {
    [cropViewController dismissViewControllerAnimated:YES completion:^{
        self.m_imgTrendImage.image = image;
        m_hasTrendImage = YES;
    }];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBtnPostIt:(id)sender {
    [self.m_txtTrendBody resignFirstResponder];
    
    NSString *strBody = [self.m_txtTrendBody.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(strBody.length > 0) {
        SVPROGRESSHUD_PLEASE_WAIT;
        [[WebService sharedInstance] createNewTrend:self.m_txtTrendBody.text
                                              Image:m_hasTrendImage ? self.m_imgTrendImage.image : nil
                                           Progress:^(double progress) {
                                               if(m_hasTrendImage) {
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       SVPROGRESSHUD_PROGRESS(progress);
                                                   });
                                               }
                                           }
                                          Completed:^(NSString *strResult, NSString *strError) {
                                              if(!strError) {
                                                  SVPROGRESSHUD_SUCCESS(strResult);
                                                  self.m_txtTrendBody.text = @"";
                                                  self.m_imgTrendImage.image = nil;
                                                  m_hasTrendImage = NO;
                                                  
                                                  [GlobalService sharedInstance].user_tabbar.selectedIndex = USER_ME_TABBAR_INDEX;
                                              } else {
                                                  SVPROGRESSHUD_ERROR(strError);
                                              }
                                          }];
    } else {
        [self.view makeToast:TOAST_MESSAGE_TREND_NO_BODY duration:2.f position:CSToastPositionCenter];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    if(string.length == 0)
        return YES;
    
    if(textView.text.length == 147)
        return NO;

    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    long int len = textView.text.length;
    self.m_lblCharacters.text =[NSString stringWithFormat:@"%li characters left", 147 - len];
}

@end
