//
//  JHTextField.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 4/8/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "JHTextField.h"

@implementation JHTextField

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.left_padding, 20)];
    self.leftView = leftPadding;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = self.border_width;
    self.layer.borderColor = self.border_color.CGColor;
    self.layer.cornerRadius = self.corner_radius;
    
    if(self.custom_font.length == 0) {
        self.custom_font = @"SYSTEM";
    }
    
    self.font = [UIFont fontWithName:self.custom_font size:self.font.pointSize];
}

@end
