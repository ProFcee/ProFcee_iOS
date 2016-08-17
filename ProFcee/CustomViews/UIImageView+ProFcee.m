//
//  UIImageView+ProFcee.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/30/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "UIImageView+ProFcee.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@implementation UIImageView(ProFcee)

- (void)setImageWithUrl:(NSString *)url withPlaceholder:(NSString *)imgPlaceholder {
    if(url.length > 0) {        
        DGActivityIndicatorView *activityIndicatorView = [self addActivityIndicatorViewSize:40.f];
        [activityIndicatorView startAnimating];
        
        __weak UIImageView *weakSelf = self;
        [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                    placeholderImage:imgPlaceholder ? [UIImage imageNamed:imgPlaceholder] : nil
                             success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                 weakSelf.image = image;
                                 [activityIndicatorView removeFromSuperview];
                             }
                             failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                 NSLog(@"%@", error.localizedDescription);
                                 [activityIndicatorView removeFromSuperview];
                             }];
    } else {
        self.image = [UIImage imageNamed:imgPlaceholder];
    }
}

- (DGActivityIndicatorView *)addActivityIndicatorViewSize:(CGFloat)size {
    //remove old activity view
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[DGActivityIndicatorView class]]) {
            [view removeFromSuperview];
        }
    }
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotate
                                                                                         tintColor:[UIColor whiteColor]
                                                                                              size:size];
    
    [self addSubview:activityIndicatorView];
    
    //add constraint
    [activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //center x
    [self addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.f
                                                      constant:0.f]];
    
    //center y
    [self addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.f
                                                      constant:0.f]];
    
    return activityIndicatorView;
}

@end
