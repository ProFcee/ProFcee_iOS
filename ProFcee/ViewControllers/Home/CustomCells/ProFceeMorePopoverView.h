//
//  ProFceeMorePopoverView.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 19/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    POPOVER_MORE_SETTINGS = 10,
    POPOVER_MORE_ABOUT_US,
    POPOVER_MORE_TERMS,
    POPOVER_MORE_PRIVACY
}POPOVER_MORE_BUTTON_INDEX;

@protocol ProFceeMorePopoverViewDelegate <NSObject>

@optional
- (void)didSelectedItem:(POPOVER_MORE_BUTTON_INDEX)index;

@end

@interface ProFceeMorePopoverView : UIView

@property (nonatomic, retain) UIViewController      *m_parentVC;
@property (nonatomic, retain) id<ProFceeMorePopoverViewDelegate> delegate;

- (IBAction)onSelectItem:(id)sender;

@end
