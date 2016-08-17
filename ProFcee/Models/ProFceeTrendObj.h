//
//  ProFceeTrendObj.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProFceeTrendObj : NSObject

@property (nonatomic, retain) NSNumber          *trend_id;
@property (nonatomic, retain) NSString          *trend_body;
@property (nonatomic, retain) NSNumber          *trend_user_id;
@property (nonatomic, retain) NSString          *trend_image;
@property (nonatomic, readwrite) BOOL           trend_agreed;
@property (nonatomic, readwrite) BOOL           trend_abused;
@property (nonatomic, retain) NSNumber          *trend_agrees;
@property (nonatomic, readwrite) BOOL           trend_deleted;
@property (nonatomic, readwrite) BOOL           trend_share;
@property (nonatomic, retain) NSNumber          *trend_share_trend_id;
@property (nonatomic, readwrite) BOOL           trend_toprated;
@property (nonatomic, readwrite) BOOL           trend_pick;
@property (nonatomic, retain) NSNumber          *trend_city_id;
@property (nonatomic, retain) NSString          *trend_location;
@property (nonatomic, retain) NSDate            *trend_created;

- (ProFceeTrendObj *)initWithDictionary:(NSDictionary *)dicTrend;
- (NSDictionary *)currentDictionary;

- (NSString *)trendUrl;

@end
