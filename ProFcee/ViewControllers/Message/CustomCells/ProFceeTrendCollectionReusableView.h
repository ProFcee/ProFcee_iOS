//
//  ProFceeTrendCollectionReusableView.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/6/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProFceeTrendCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *m_lblTrendBody;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgTrend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *m_constraintImageHeight;

+ (UINib *)nib;
+ (NSString *)headerReuseIdentifier;

@end
