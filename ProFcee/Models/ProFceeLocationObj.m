//
//  ProFceeLocationObj.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/28/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeLocationObj.h"

@implementation ProFceeCountryObj

- (id)init {
    self = [super init];
    if(self) {
        self.country_id = @0;
        self.country_name = @"";
        self.country_sortname = @"";
    }
    
    return self;
}

- (ProFceeCountryObj *)initWithDictionary:(NSDictionary *)dicCountryObj {
    ProFceeCountryObj *objCountry = [[ProFceeCountryObj alloc] init];
    
    if(dicCountryObj[@"id"] && ![dicCountryObj[@"id"] isEqual:[NSNull null]]) {
        objCountry.country_id = [NSNumber numberWithInt:[dicCountryObj[@"id"] intValue]];
    }
    
    if(dicCountryObj[@"name"] && ![dicCountryObj[@"name"] isEqual:[NSNull null]]) {
        objCountry.country_name = dicCountryObj[@"name"];
    }
    
    if(dicCountryObj[@"sortname"] && ![dicCountryObj[@"sortname"] isEqual:[NSNull null]]) {
        objCountry.country_sortname = dicCountryObj[@"sortname"];
    }
    
    return objCountry;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"id":         self.country_id,
             @"name":       self.country_name,
             @"sortname":   self.country_sortname
             };
}

@end

@implementation ProFceeStateObj

- (id)init {
    self = [super init];
    if(self) {
        self.state_id = @0;
        self.state_name = @"";
        self.state_code = @"";
        self.state_country_id = @"";
        self.state_country = [[ProFceeCountryObj alloc] init];
    }
    
    return self;
}

- (ProFceeStateObj *)initWithDictionary:(NSDictionary *)dicStateObj {
    ProFceeStateObj *objState = [[ProFceeStateObj alloc] init];
    
    if(dicStateObj[@"id"] && ![dicStateObj[@"id"] isEqual:[NSNull null]]) {
        objState.state_id = [NSNumber numberWithInt:[dicStateObj[@"id"] intValue]];
    }
    
    if(dicStateObj[@"name"] && ![dicStateObj[@"name"] isEqual:[NSNull null]]) {
        objState.state_name = dicStateObj[@"name"];
    }
    
    if(dicStateObj[@"code"] && ![dicStateObj[@"code"] isEqual:[NSNull null]]) {
        objState.state_code = dicStateObj[@"code"];
    }
    
    if(dicStateObj[@"country_id"] && ![dicStateObj[@"country_id"] isEqual:[NSNull null]]) {
        objState.state_country_id = dicStateObj[@"country_id"];
    }
    
    if(dicStateObj[@"Country"] && ![dicStateObj[@"Country"] isEqual:[NSNull null]]) {
        objState.state_country = [[ProFceeCountryObj alloc] initWithDictionary:dicStateObj[@"Country"]];
    }
    
    return objState;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"id":         self.state_id,
             @"name":       self.state_name,
             @"code":       self.state_code,
             @"country_id": self.state_country_id,
             @"Country":    self.state_country.currentDictionary
             };
}

@end

@implementation ProFceeCityObj

- (id)init {
    self = [super init];
    if(self) {
        self.city_id = @0;
        self.city_name = @"";
        self.city_timezone = @"";
        self.city_code = @"";
        self.city_latitude = @0;
        self.city_longitude = @0;
        self.city_state_id = @0;
        self.city_state = [[ProFceeStateObj alloc] init];
    }
    
    return self;
}

- (ProFceeCityObj *)initWithDictionary:(NSDictionary *)dicCityObj {
    ProFceeCityObj *objCity = [[ProFceeCityObj alloc] init];
    
    if(dicCityObj[@"id"] && ![dicCityObj[@"id"] isEqual:[NSNull null]]) {
        objCity.city_id = [NSNumber numberWithInt:[dicCityObj[@"id"] intValue]];
    }
    
    if(dicCityObj[@"name"] && ![dicCityObj[@"name"] isEqual:[NSNull null]]) {
        objCity.city_name = dicCityObj[@"name"];
    }
    
    if(dicCityObj[@"Code"] && ![dicCityObj[@"Code"] isEqual:[NSNull null]]) {
        objCity.city_code = dicCityObj[@"Code"];
    }
    
    if(dicCityObj[@"TimeZone"] && ![dicCityObj[@"TimeZone"] isEqual:[NSNull null]]) {
        objCity.city_timezone = dicCityObj[@"TimeZone"];
    }
    
    if(dicCityObj[@"Latitude"] && ![dicCityObj[@"Latitude"] isEqual:[NSNull null]]) {
        objCity.city_latitude = [NSNumber numberWithFloat:[dicCityObj[@"Latitude"] floatValue]];
    }
    
    if(dicCityObj[@"Longitude"] && ![dicCityObj[@"Longitude"] isEqual:[NSNull null]]) {
        objCity.city_longitude = [NSNumber numberWithFloat:[dicCityObj[@"Longitude"] floatValue]];
    }
    
    if(dicCityObj[@"state_id"] && ![dicCityObj[@"state_id"] isEqual:[NSNull null]]) {
        objCity.city_state_id = [NSNumber numberWithInt:[dicCityObj[@"state_id"] intValue]];
    }
    
    if(dicCityObj[@"State"] && ![dicCityObj[@"State"] isEqual:[NSNull null]]) {
        objCity.city_state = [[ProFceeStateObj alloc] initWithDictionary:dicCityObj[@"State"]];
    }
    
    return objCity;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"id":         self.city_id,
             @"name":       self.city_name,
             @"Code":       self.city_code,
             @"TimeZone":   self.city_timezone,
             @"Latitude":   self.city_latitude,
             @"Longitude":  self.city_longitude,
             @"state_id":   self.city_state_id,
             @"State":      self.city_state.currentDictionary
             };
}

@end
