//
//  GlobalService.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 4/10/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "GlobalService.h"

@implementation GlobalService

static GlobalService *_globalService = nil;

+ (GlobalService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_globalService == nil) {
            _globalService = [[self alloc] init]; // assignment not done here
        }
    });
    
    return _globalService;
}

- (id)init {
    self = [super init];
    if(self) {
        self.is_internet_alive = YES;
        self.device_token = @"";
        self.user_city = [[ProFceeCityObj alloc] init];
        self.search_history = [[self getSearchHistory] mutableCopy];
    }
    
    return self;
}

- (ProFceeUserMe *)loadMe {
    ProFceeUserMe *objMe = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dicMe = [defaults objectForKey:USER_DEFAULTS_KEY_ME];
    if(dicMe) {
        objMe = [[ProFceeUserMe alloc] initWithDictionary:dicMe];
    }
    
    return objMe;
}

- (void)saveMe {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user_me.currentDictionary forKey:USER_DEFAULTS_KEY_ME];
    [defaults synchronize];
}

- (void)removeMe {
    self.user_me = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER_DEFAULTS_KEY_ME];
    [defaults synchronize];
}

- (NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(dateFormat) {
        formatter.dateFormat = dateFormat;
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDate *date = [formatter dateFromString:strDate];
    if(date == nil) {
        date = [NSDate date];
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval nDifferent = zone.secondsFromGMT;
    
    return [date dateByAddingTimeInterval:nDifferent];
}

- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if(dateFormat) {
        formatter.dateFormat = dateFormat;
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    
    return [formatter stringFromDate:date];
}

- (ProFceeCountryObj *)getCountryWithName:(NSString *)country_name {
    ProFceeCountryObj *objCountry = self.user_countries[0];
    
    for(ProFceeCountryObj *tmpCountry in self.user_countries) {
        if([tmpCountry.country_name isEqualToString:country_name]
           || [tmpCountry.country_sortname isEqualToString:country_name]) {
            objCountry = tmpCountry;
            break;
        }
    }
    
    return objCountry;
}

- (ProFceeStateObj *)getStateWithName:(NSString *)state_name {
    ProFceeStateObj *objState = self.user_states[0];
    
    for(ProFceeStateObj *tmpState in self.user_states) {
        if([tmpState.state_code isEqualToString:state_name]
           || [tmpState.state_name isEqualToString:state_name]) {
            objState = tmpState;
            break;
        }
    }
    
    return objState;
}

- (ProFceeCityObj *)getCityWithName:(NSString *)city_name {
    ProFceeCityObj *objCity = self.user_cities[0];
    
    for(ProFceeCityObj *tmpCity in self.user_cities) {
        if([tmpCity.city_name isEqualToString:city_name]
           || [tmpCity.city_code isEqualToString:city_name]) {
            objCity = tmpCity;
            break;
        }
    }
    
    return objCity;
}

- (NSArray *)getSearchHistory {
    NSArray *arySearchHisotry = @[];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:USER_DEFAULTS_KEY_SEARCH_HISTORY]) {
        arySearchHisotry = [defaults objectForKey:USER_DEFAULTS_KEY_SEARCH_HISTORY];
    }
    
    return arySearchHisotry;
}

- (void)addSearchHistory:(NSString *)search {
    if(![self.search_history containsObject:search]) {
        [self.search_history addObject:search];
        
        while(self.search_history.count > 10) {
            [self.search_history removeObjectAtIndex:0];
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.search_history forKey:USER_DEFAULTS_KEY_SEARCH_HISTORY];
        [defaults synchronize];
    }
}

@end
