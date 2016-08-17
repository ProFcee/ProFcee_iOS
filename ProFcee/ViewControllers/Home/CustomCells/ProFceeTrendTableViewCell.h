//
//  ProFceeTrendTableViewCell.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 19/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProFceeTrendTableViewCellDelegate <NSObject>

@optional
- (void)onClickBtnAgreeAtRow:(NSInteger)row;
- (void)onClickBtnShareAtRow:(NSInteger)row;
- (void)onClickBtnReportAtRow:(NSInteger)row;
- (void)onTapTrendOwnerAvatar:(NSInteger)row;
- (void)onTapUserAgrees:(NSInteger)row;

@end

@interface ProFceeTrendTableViewCell : UITableViewCell {
    ProFceeTrendInfoObj     *m_objTrendInfo;
    NSInteger               m_nRow;
}

@property (weak, nonatomic) IBOutlet UIImageView        *m_imgUserAvatar;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblUserName;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblTrendLocation;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblUserInformation;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblTrendAgrees;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblTrendCreated;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblTrendBody;
@property (weak, nonatomic) IBOutlet UIImageView        *m_imgTrend;
@property (weak, nonatomic) IBOutlet UIButton           *m_btnAgree;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintTrendImageHeight;

@property (nonatomic, retain) id<ProFceeTrendTableViewCellDelegate> delegate;

- (void)setViewsWithTrendInfoObj:(ProFceeTrendInfoObj *)objTrendInfo atRow:(NSInteger)row;

- (IBAction)onClickBtnAgree:(id)sender;
- (IBAction)onClickBtnShare:(id)sender;
- (IBAction)onClickBtnReport:(id)sender;
- (IBAction)onTapUserAvatar:(id)sender;
- (IBAction)onTapUserAgrees:(id)sender;

@end
