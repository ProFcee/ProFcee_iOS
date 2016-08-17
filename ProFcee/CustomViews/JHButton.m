//
//  JHButton.m
//  CloudShop
//
//  Created by Dealyourself Internet Private Limited on 4/19/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "JHButton.h"

@implementation JHButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = self.border_width;
    self.layer.borderColor = self.border_color.CGColor;
    self.layer.cornerRadius = self.corner_radius;
    
    if(self.custom_font.length == 0) {
        self.custom_font = @"SYSTEM";
    }
    
    self.titleLabel.font = [UIFont fontWithName:self.custom_font size:self.titleLabel.font.pointSize];
}

@end
