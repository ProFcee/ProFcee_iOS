//
//  ProFceeNotificationTableViewCell.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProFceeNotificationTableViewCellDelegate <NSObject>

@optional
- (void)onTapUserAvatar:(ProFceeNotificationObj *)objNotification;

@end

@interface ProFceeNotificationTableViewCell : UITableViewCell {
    ProFceeNotificationObj *m_objNotification;
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgSenderAvatar;
@property (weak, nonatomic) IBOutlet UILabel *m_lblSenderName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblNotificationText;
@property (weak, nonatomic) IBOutlet UILabel *m_lblTime;

@property (nonatomic, retain) id<ProFceeNotificationTableViewCellDelegate> delegate;

- (void)setViewsWithNotificationObj:(ProFceeNotificationObj *)objNotification;

@end
