//
//  JHView.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 4/8/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "JHView.h"

@implementation JHView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    self.layer.masksToBounds = YES;
    self.layer.borderColor = self.border_color.CGColor;
    self.layer.borderWidth = self.border_width;
    self.layer.cornerRadius = self.corner_radius;
}

@end
