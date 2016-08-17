//
//  JHLabel.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/9/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "JHLabel.h"

@implementation JHLabel

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    if(self.custom_font.length == 0) {
        self.custom_font = @"SYSTEM";
    }
    
    self.font = [UIFont fontWithName:self.custom_font size:self.font.pointSize];
}

@end
