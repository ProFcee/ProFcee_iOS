//
//  ProFceeTrendInfoObj.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeTrendInfoObj.h"

@implementation ProFceeTrendInfoObj

- (id)init {
    self = [super init];
    if(self) {
        self.trend_info_trend = [[ProFceeTrendObj alloc] init];
        self.trend_info_user = [[ProFceeUserObj alloc] init];
    }
    
    return self;
}

- (ProFceeTrendInfoObj *)initWithDictionary:(NSDictionary *)dicTrendInfo {
    ProFceeTrendInfoObj *objTrendInfo = [[ProFceeTrendInfoObj alloc] init];
    
    if(dicTrendInfo[@"Trend"] && ![dicTrendInfo[@"Trend"] isEqual:[NSNull null]]) {
        objTrendInfo.trend_info_trend = [[ProFceeTrendObj alloc] initWithDictionary:dicTrendInfo[@"Trend"]];
    }
    
    if(dicTrendInfo[@"User"] && ![dicTrendInfo[@"User"] isEqual:[NSNull null]]) {
        objTrendInfo.trend_info_user = [[ProFceeUserObj alloc] initWithDictionary:dicTrendInfo[@"User"]];
    }
    
    return objTrendInfo;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"Trend":          self.trend_info_trend.currentDictionary,
             @"User":           self.trend_info_user.currentDictionary
             };
}

@end
