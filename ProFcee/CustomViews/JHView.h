//
//  JHView.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 4/8/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE @interface JHView : UIView

@property (nonatomic, retain) IBInspectable UIColor         *border_color;
@property (nonatomic, readwrite) IBInspectable CGFloat      border_width;
@property (nonatomic, readwrite) IBInspectable CGFloat      corner_radius;

@end
