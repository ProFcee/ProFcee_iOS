//
//  ProFceeUserObj.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProFceeUserObj : NSObject

@property (nonatomic, retain) NSNumber      *user_id;
@property (nonatomic, retain) NSString      *user_name;
@property (nonatomic, retain) NSString      *user_email;
@property (nonatomic, retain) NSString      *user_gender;
@property (nonatomic, retain) NSDate        *user_dob;
@property (nonatomic, retain) NSString      *user_organisation;
@property (nonatomic, retain) NSString      *user_designation;
@property (nonatomic, retain) NSNumber      *user_city_id;
@property (nonatomic, retain) NSString      *user_city;
@property (nonatomic, retain) NSString      *user_profile_image;
@property (nonatomic, retain) NSString      *user_banner_image;
@property (nonatomic, readwrite) BOOL       user_active;
@property (nonatomic, retain) NSDate        *user_created;
@property (nonatomic, retain) NSDate        *user_modified;

- (ProFceeUserObj *)initWithDictionary:(NSDictionary *)dicUser;
- (NSDictionary *)currentDictionary;

- (NSString *)avatarUrl;
- (NSString *)bannerUrl;

@end
