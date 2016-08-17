//
//  JHButton.h
//  CloudShop
//
//  Created by Dealyourself Internet Private Limited on 4/19/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface JHButton : UIButton

@property (nonatomic, readwrite) IBInspectable CGFloat  border_width;
@property (nonatomic, readwrite) IBInspectable CGFloat  corner_radius;
@property (nonatomic, retain) IBInspectable UIColor     *border_color;
@property (nonatomic, retain) IBInspectable NSString    *custom_font;

@end
