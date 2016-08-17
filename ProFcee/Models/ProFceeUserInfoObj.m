//
//  ProFceeUserInfoObj.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeUserInfoObj.h"

@implementation ProFceeUserInfoObj

- (id)init {
    self = [super init];
    if(self) {
        self.user_info_city = [[ProFceeCityObj alloc] init];
        self.user_info_user = [[ProFceeUserObj alloc] init];
    }
    
    return self;
}

- (ProFceeUserInfoObj *)initWithDictionary:(NSDictionary *)dicUserInfo {
    ProFceeUserInfoObj *objUserInfo = [[ProFceeUserInfoObj alloc] init];
    
    if(dicUserInfo[@"City"] && ![dicUserInfo[@"City"] isEqual:[NSNull null]]) {
        objUserInfo.user_info_city = [[ProFceeCityObj alloc] initWithDictionary:dicUserInfo[@"City"]];
    }
    
    if(dicUserInfo[@"User"] && ![dicUserInfo[@"User"] isEqual:[NSNull null]]) {
        objUserInfo.user_info_user = [[ProFceeUserObj alloc] initWithDictionary:dicUserInfo[@"User"]];
    }
    
    return objUserInfo;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"City":   self.user_info_city.currentDictionary,
             @"User":   self.user_info_user.currentDictionary
             };
}


@end
