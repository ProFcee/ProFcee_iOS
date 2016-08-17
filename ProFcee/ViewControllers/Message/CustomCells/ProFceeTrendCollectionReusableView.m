//
//  ProFceeTrendCollectionReusableView.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/6/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeTrendCollectionReusableView.h"

@implementation ProFceeTrendCollectionReusableView

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([ProFceeTrendCollectionReusableView class])
                          bundle:[NSBundle bundleForClass:[ProFceeTrendCollectionReusableView class]]];
}

+ (NSString *)headerReuseIdentifier
{
    return NSStringFromClass([ProFceeTrendCollectionReusableView class]);
}

@end
