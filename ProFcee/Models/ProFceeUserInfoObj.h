//
//  ProFceeUserInfoObj.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProFceeUserInfoObj : NSObject

@property (nonatomic, retain) ProFceeCityObj            *user_info_city;
@property (nonatomic, retain) ProFceeUserObj            *user_info_user;

- (ProFceeUserInfoObj *)initWithDictionary:(NSDictionary *)dicUserInfo;
- (NSDictionary *)currentDictionary;

@end
