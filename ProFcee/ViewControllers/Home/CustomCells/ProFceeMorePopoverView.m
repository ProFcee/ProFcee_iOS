//
//  ProFceeMorePopoverView.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 19/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeMorePopoverView.h"

@implementation ProFceeMorePopoverView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onSelectItem:(id)sender {
    UIButton *btnItem = (UIButton *)sender;
    
    switch (btnItem.tag) {
        case POPOVER_ITEM_SETTINGS:
            
            break;
        
        case POPOVER_ITEM_ABOUTUS:
            
            break;
            
        case POPOVER_ITEM_TERMS:
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:PROFCEE_TERMS_URL]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PROFCEE_TERMS_URL]];
            }
            break;
            
        case POPOVER_ITEM_PRIVACY:
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:PROFCEE_PRIVACY_URL]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PROFCEE_PRIVACY_URL]];
            }
            break;
    }
    
    [self.delegate didSelectedItem:(POPOVER_MORE_BUTTON_INDEX)btnItem.tag];
}

@end
