//
//  ProFceePostViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TOCropViewController/TOCropViewController.h>

@interface ProFceePostViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, TOCropViewControllerDelegate> {
    BOOL    m_hasTrendImage;
}

@property (weak, nonatomic) IBOutlet UITextView *m_txtTrendBody;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTrendImageStatus;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgTrendImage;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCharacters;

- (IBAction)onClickBtnBack:(id)sender;
- (IBAction)onTapTrendImage:(id)sender;
- (IBAction)onClickBtnPostIt:(id)sender;

@end
