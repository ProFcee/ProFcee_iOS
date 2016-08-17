//
//  ProFceeUserTableViewCell.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProFceeUserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *m_imgUserAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblBadge;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblUserName;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblUserLocation;
@property (weak, nonatomic) IBOutlet UIButton       *m_btnCheck;

- (void)setViewsWithUserInfoObj:(ProFceeUserInfoObj *)objUserInfo;

@end
