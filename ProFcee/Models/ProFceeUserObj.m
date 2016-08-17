//
//  ProFceeUserObj.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeUserObj.h"

@implementation ProFceeUserObj

- (id)init {
    self = [super init];
    if(self) {
        self.user_id = @0;
        self.user_name = @"";
        self.user_email = @"";
        self.user_gender = @"";
        self.user_dob = [NSDate dateWithTimeIntervalSince1970:0];
        self.user_organisation = @"";
        self.user_designation = @"";
        self.user_city_id = @0;
        self.user_city = @"";
        self.user_profile_image = @"";
        self.user_banner_image = @"";
        self.user_active = NO;
        self.user_created = [NSDate date];
        self.user_modified = [NSDate date];
    }
    
    return self;
}

- (ProFceeUserObj *)initWithDictionary:(NSDictionary *)dicUser {
    ProFceeUserObj *objUser = [[ProFceeUserObj alloc] init];
    
    if(dicUser[@"id"] && ![dicUser[@"id"] isEqual:[NSNull null]]) {
        objUser.user_id = [NSNumber numberWithInt:[dicUser[@"id"] intValue]];
    }
    
    if(dicUser[@"name"] && ![dicUser[@"name"] isEqual:[NSNull null]]) {
        objUser.user_name = [dicUser[@"name"] uppercaseString];
    }
    
    if(dicUser[@"email"] && ![dicUser[@"email"] isEqual:[NSNull null]]) {
        objUser.user_email = dicUser[@"email"];
    }
    
    if(dicUser[@"gender"] && ![dicUser[@"gender"] isEqual:[NSNull null]]) {
        objUser.user_gender = dicUser[@"gender"];
    }
    
    if(dicUser[@"dob"] && ![dicUser[@"dob"] isEqual:[NSNull null]]) {
        objUser.user_dob = [[GlobalService sharedInstance] dateFromString:dicUser[@"dob"] withFormat:@"yyyy-MM-dd"];
    }
    
    if(dicUser[@"organisation"] && ![dicUser[@"organisation"] isEqual:[NSNull null]]) {
        objUser.user_organisation = dicUser[@"organisation"];
    }
    
    if(dicUser[@"designation"] && ![dicUser[@"designation"] isEqual:[NSNull null]]) {
        objUser.user_designation = dicUser[@"designation"];
    }
    
    if(dicUser[@"city_id"] && ![dicUser[@"city_id"] isEqual:[NSNull null]]) {
        objUser.user_city_id = [NSNumber numberWithInt:[dicUser[@"city_id"] intValue]];
    }
    
    if(dicUser[@"city"] && ![dicUser[@"city"] isEqual:[NSNull null]]) {
        objUser.user_city = dicUser[@"city"];
    }
    
    if(dicUser[@"profile_image"] && ![dicUser[@"profile_image"] isEqual:[NSNull null]]) {
        objUser.user_profile_image = dicUser[@"profile_image"];
    }
    
    if(dicUser[@"banner_image"] && ![dicUser[@"banner_image"] isEqual:[NSNull null]]) {
        objUser.user_banner_image = dicUser[@"banner_image"];
    }
    
    if(dicUser[@"active"] && ![dicUser[@"active"] isEqual:[NSNull null]]) {
        objUser.user_active = [dicUser[@"active"] boolValue];
    }
    
    if(dicUser[@"created"] && ![dicUser[@"created"] isEqual:[NSNull null]]) {
        objUser.user_created = [[GlobalService sharedInstance] dateFromString:dicUser[@"created"] withFormat:nil];
    }
    
    if(dicUser[@"modified"] && ![dicUser[@"modified"] isEqual:[NSNull null]]) {
        objUser.user_modified = [[GlobalService sharedInstance] dateFromString:dicUser[@"modified"] withFormat:nil];
    }
    
    return objUser;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"id":             self.user_id,
             @"name":           self.user_name,
             @"email":          self.user_email,
             @"gender":         self.user_gender,
             @"dob":            [[GlobalService sharedInstance] stringFromDate:self.user_dob withFormat:@"yyyy-MM-dd"],
             @"organisation":   self.user_organisation,
             @"designation":    self.user_designation,
             @"city_id":        self.user_city_id,
             @"city":           self.user_city,
             @"profile_image":  self.user_profile_image,
             @"banner_image":   self.user_banner_image,
             @"active":         [NSNumber numberWithBool:self.user_active],
             @"created":        [[GlobalService sharedInstance] stringFromDate:self.user_created withFormat:nil],
             @"modified":       [[GlobalService sharedInstance] stringFromDate:self.user_modified withFormat:nil]
             };
}

- (NSString *)avatarUrl {
    NSString *url = self.user_profile_image;
    
    if(![self.user_profile_image containsString:@"http"]) {
        if(self.user_profile_image.length > 0) {
            url = [NSString stringWithFormat:@"%@%@%@", [WebService sharedInstance].m_strProfceeDomain, @"/assets/avatar/", self.user_profile_image];
        } else {
            url = [NSString stringWithFormat:@"%@%@", [WebService sharedInstance].m_strProfceeDomain, @"/assets/avatar/default.jpg"];
        }
    }
    
    return url;
}

- (NSString *)bannerUrl {
    NSString *url = self.user_banner_image;
    
    if(![self.user_banner_image containsString:@"http"]) {
        if(self.user_banner_image.length > 0) {
            url = [NSString stringWithFormat:@"%@%@%@", [WebService sharedInstance].m_strProfceeDomain, @"/assets/banner/", self.user_banner_image];
        } else {
            url = [NSString stringWithFormat:@"%@%@", [WebService sharedInstance].m_strProfceeDomain, @"/assets/banner/default.jpg"];
        }
    }
    return url;
}

@end
