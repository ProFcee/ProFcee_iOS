//
//  ProFceeLocationObj.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/28/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProFceeCountryObj : NSObject

@property (nonatomic, retain) NSNumber          *country_id;
@property (nonatomic, retain) NSString          *country_name;
@property (nonatomic, retain) NSString          *country_sortname;

- (ProFceeCountryObj *)initWithDictionary:(NSDictionary *)dicCountryObj;
- (NSDictionary *)currentDictionary;

@end

@interface ProFceeStateObj : NSObject

@property (nonatomic, retain) NSNumber          *state_id;
@property (nonatomic, retain) NSString          *state_name;
@property (nonatomic, retain) NSString          *state_code;
@property (nonatomic, retain) NSString          *state_country_id;
@property (nonatomic, retain) ProFceeCountryObj *state_country;

- (ProFceeStateObj *)initWithDictionary:(NSDictionary *)dicStateObj;
- (NSDictionary *)currentDictionary;

@end

@interface ProFceeCityObj : NSObject

@property (nonatomic, retain) NSNumber          *city_id;
@property (nonatomic, retain) NSString          *city_name;
@property (nonatomic, retain) NSString          *city_code;
@property (nonatomic, retain) NSNumber          *city_latitude;
@property (nonatomic, retain) NSNumber          *city_longitude;
@property (nonatomic, retain) NSString          *city_timezone;
@property (nonatomic, retain) NSNumber          *city_state_id;
@property (nonatomic, retain) ProFceeStateObj   *city_state;

- (ProFceeCityObj *)initWithDictionary:(NSDictionary *)dicCityObj;
- (NSDictionary *)currentDictionary;

@end
