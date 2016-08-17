//
//  ProFceeTrendTableViewCell.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 19/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeTrendTableViewCell.h"

@implementation ProFceeTrendTableViewCell

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

- (void)setViewsWithTrendInfoObj:(ProFceeTrendInfoObj *)objTrendInfo atRow:(NSInteger)row {
    m_objTrendInfo = objTrendInfo;
    m_nRow = row;
    
    [self.m_imgUserAvatar setImageWithUrl:objTrendInfo.trend_info_user.avatarUrl
                          withPlaceholder:nil];
    self.m_lblUserName.text = objTrendInfo.trend_info_user.user_name;
    self.m_lblTrendLocation.text = objTrendInfo.trend_info_trend.trend_location;
    
    NSString *strUserInformation = @"";
    if(objTrendInfo.trend_info_user.user_designation.length > 0) {
        strUserInformation = [NSString stringWithFormat:@"%@, ", objTrendInfo.trend_info_user.user_designation];
    }
    
    if(objTrendInfo.trend_info_user.user_organisation.length > 0) {
        strUserInformation = [NSString stringWithFormat:@"%@%@", strUserInformation, objTrendInfo.trend_info_user.user_organisation];
    }
    
    self.m_lblUserInformation.text = strUserInformation;
    if(objTrendInfo.trend_info_trend.trend_agrees.intValue > 1) {
        self.m_lblTrendAgrees.text = [NSString stringWithFormat:@"%d agrees", objTrendInfo.trend_info_trend.trend_agrees.intValue];
    } else {
        self.m_lblTrendAgrees.text = [NSString stringWithFormat:@"%d agree", objTrendInfo.trend_info_trend.trend_agrees.intValue];
    }
    self.m_lblTrendCreated.text = objTrendInfo.trend_info_trend.trend_created.formattedAsTimeAgo;
    self.m_lblTrendBody.text = objTrendInfo.trend_info_trend.trend_body;
    [self.m_imgTrend setImageWithUrl:objTrendInfo.trend_info_trend.trendUrl withPlaceholder:nil];
    self.m_btnAgree.selected = objTrendInfo.trend_info_trend.trend_agreed;
}

- (IBAction)onClickBtnAgree:(id)sender {
    UIButton *btnAgree = (UIButton *)sender;
    if(!btnAgree.selected) {
        [self.delegate onClickBtnAgreeAtRow:m_nRow];
    }
}

- (IBAction)onClickBtnShare:(id)sender {
    [self.delegate onClickBtnShareAtRow:m_nRow];
}

- (IBAction)onClickBtnReport:(id)sender {
    [self.delegate onClickBtnReportAtRow:m_nRow];
}

- (IBAction)onTapUserAvatar:(id)sender {
    [self.delegate onTapTrendOwnerAvatar:m_nRow];
}

- (IBAction)onTapUserAgrees:(id)sender {
    [self.delegate onTapUserAgrees:m_nRow];
}

@end
