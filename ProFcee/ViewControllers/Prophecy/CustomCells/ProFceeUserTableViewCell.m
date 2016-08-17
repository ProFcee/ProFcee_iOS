//
//  ProFceeUserTableViewCell.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeUserTableViewCell.h"

@implementation ProFceeUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.m_imgUserAvatar.layer.masksToBounds = YES;
    self.m_imgUserAvatar.layer.cornerRadius = CGRectGetHeight(self.m_imgUserAvatar.frame) / 2.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithUserInfoObj:(ProFceeUserInfoObj *)objUserInfo {
    [self.m_imgUserAvatar setImageWithUrl:objUserInfo.user_info_user.avatarUrl
                          withPlaceholder:nil];
    self.m_lblUserName.text = objUserInfo.user_info_user.user_name;
    self.m_lblUserLocation.text = [NSString stringWithFormat:@"%@, %@", objUserInfo.user_info_city.city_name, objUserInfo.user_info_city.city_state.state_country.country_name];
}

@end
