//
//  JHTextView.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/9/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTextView : UITextView

@property (nonatomic, retain) IBInspectable UIColor         *border_color;
@property (nonatomic, readwrite) IBInspectable CGFloat      border_width;
@property (nonatomic, readwrite) IBInspectable CGFloat      corner_radius;
@property (nonatomic, retain) IBInspectable NSString        *custom_font;

@end
