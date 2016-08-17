//
//  JHParallaxViewController.h
//  ParallaxTest
//
//  Created by Dealyourself Internet Private Limited on 2/19/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>

@interface JHParallaxViewController : JSQMessagesViewController<UIScrollViewDelegate> {
    NSLayoutConstraint  *headerViewHeightConstraint;
    BOOL                headerBeganCollapsed;
    CGFloat             collapsedHeaderViewHeight;
    CGFloat             expandedHeaderViewHeight;
    CGFloat             headerExpandDelay;
    CGFloat             tableViewScrollOffsetBeginDraggingY;
}

@property (nonatomic, retain) IBOutlet  UIView              *m_viewHeader;
@property (nonatomic, retain) IBOutlet  UIScrollView        *m_viewScroll;

@end
