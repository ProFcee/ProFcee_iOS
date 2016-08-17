//
//  ProFceeNotificationTableViewCell.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeNotificationTableViewCell.h"

@implementation ProFceeNotificationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(onTapUserAvatar)];
    [self.m_imgSenderAvatar addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithNotificationObj:(ProFceeNotificationObj *)objNotification {
    m_objNotification = objNotification;
    
    self.m_imgSenderAvatar.layer.masksToBounds = YES;
    self.m_imgSenderAvatar.layer.cornerRadius = CGRectGetHeight(self.m_imgSenderAvatar.frame) / 2.f;
    [self.m_imgSenderAvatar setImageWithUrl:objNotification.notification_user.avatarUrl
                            withPlaceholder:nil];
    
    self.m_lblSenderName.text = objNotification.notification_user.user_name;
    self.m_lblNotificationText.text = objNotification.notification_text;
    self.m_lblTime.text = objNotification.notification_created.formattedAsTimeAgo;
}

- (void)onTapUserAvatar {
    [self.delegate onTapUserAvatar:m_objNotification];
}

@end
