//
//  ProFceeTrendObj.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeTrendObj.h"

@implementation ProFceeTrendObj

- (id)init {
    self = [super init];
    if(self) {
        self.trend_id = @0;
        self.trend_body = @"";
        self.trend_user_id = @0;
        self.trend_image = @"";
        self.trend_agreed = NO;
        self.trend_abused = NO;
        self.trend_agrees = @0;
        self.trend_deleted = NO;
        self.trend_share = NO;
        self.trend_share_trend_id = @0;
        self.trend_toprated = NO;
        self.trend_pick = NO;
        self.trend_city_id = @0;
        self.trend_location = @"";
        self.trend_created = [NSDate date];
    }
    
    return self;
}

- (ProFceeTrendObj *)initWithDictionary:(NSDictionary *)dicTrend {
    ProFceeTrendObj *objTrend = [[ProFceeTrendObj alloc] init];
    
    if(dicTrend[@"id"] && ![dicTrend[@"id"] isEqual:[NSNull null]]) {
        objTrend.trend_id = [NSNumber numberWithInt:[dicTrend[@"id"] intValue]];
    }
    
    if(dicTrend[@"body"] && ![dicTrend[@"body"] isEqual:[NSNull null]]) {
        objTrend.trend_body = dicTrend[@"body"];
    }
    
    if(dicTrend[@"user_id"] && ![dicTrend[@"user_id"] isEqual:[NSNull null]]) {
        objTrend.trend_user_id = [NSNumber numberWithInt:[dicTrend[@"user_id"] intValue]];
    }
    
    if(dicTrend[@"image"] && ![dicTrend[@"image"] isEqual:[NSNull null]]) {
        objTrend.trend_image = dicTrend[@"image"];
    }
    
    if(dicTrend[@"agreed"] && ![dicTrend[@"agreed"] isEqual:[NSNull null]]) {
        objTrend.trend_agreed = [dicTrend[@"agreed"] boolValue];
    }
    
    if(dicTrend[@"abused"] && ![dicTrend[@"abused"] isEqual:[NSNull null]]) {
        objTrend.trend_abused = [dicTrend[@"abused"] boolValue];
    }
    
    if(dicTrend[@"agrees"] && ![dicTrend[@"agrees"] isEqual:[NSNull null]]) {
        objTrend.trend_agrees = [NSNumber numberWithInt:[dicTrend[@"agrees"] intValue]];
    }
    
    if(dicTrend[@"deleted"] && ![dicTrend[@"deleted"] isEqual:[NSNull null]]) {
        objTrend.trend_deleted = [dicTrend[@"deleted"] boolValue];
    }
    
    if(dicTrend[@"share"] && ![dicTrend[@"share"] isEqual:[NSNull null]]) {
        objTrend.trend_share = [dicTrend[@"share"] boolValue];
    }
    
    if(dicTrend[@"share_trend_id"] && ![dicTrend[@"share_trend_id"] isEqual:[NSNull null]]) {
        objTrend.trend_share_trend_id = [NSNumber numberWithInt:[dicTrend[@"share_trend_id"] intValue]];
    }
    
    if(dicTrend[@"toprated"] && ![dicTrend[@"toprated"] isEqual:[NSNull null]]) {
        objTrend.trend_toprated = [dicTrend[@"toprated"] boolValue];
    }
    
    if(dicTrend[@"pick"] && ![dicTrend[@"pick"] isEqual:[NSNull null]]) {
        objTrend.trend_pick = [dicTrend[@"pick"] boolValue];
    }
    
    if(dicTrend[@"city_id"] && ![dicTrend[@"city_id"] isEqual:[NSNull null]]) {
        objTrend.trend_city_id = [NSNumber numberWithInt:[dicTrend[@"city_id"] intValue]];
    }
    
    if(dicTrend[@"location"] && ![dicTrend[@"location"] isEqual:[NSNull null]]) {
        objTrend.trend_location = dicTrend[@"location"];
    }
    
    if(dicTrend[@"created"] && ![dicTrend[@"created"] isEqual:[NSNull null]]) {
        objTrend.trend_created = [[GlobalService sharedInstance] dateFromString:dicTrend[@"created"] withFormat:nil];
    }
    
    return objTrend;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"id":         self.trend_id,
             @"body":       self.trend_body,
             @"user_id":    self.trend_user_id,
             @"image":      self.trend_image,
             @"agrees":     self.trend_agrees,
             @"deleted":    [NSNumber numberWithBool:self.trend_deleted],
             @"share":      [NSNumber numberWithBool:self.trend_share],
             @"trend_id":   self.trend_share_trend_id,
             @"toprated":   [NSNumber numberWithBool:self.trend_toprated],
             @"pick":       [NSNumber numberWithBool:self.trend_pick],
             @"city_id":    self.trend_city_id,
             @"location":   self.trend_location,
             @"created":    [[GlobalService sharedInstance] stringFromDate:self.trend_created withFormat:nil]
             };
}

- (NSString *)trendUrl {
    NSString *url = self.trend_image;
    
    if(![self.trend_image containsString:@"http"]
       && self.trend_image.length > 0) {
        url = [NSString stringWithFormat:@"%@%@%@", [WebService sharedInstance].m_strProfceeDomain, @"/assets/trend/", self.trend_image];
    }
    
    return url;
}

@end
