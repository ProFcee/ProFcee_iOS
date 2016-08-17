//
//  ProFceeTrendInfoObj.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProFceeTrendObj.h"
#import "ProFceeUserObj.h"

@interface ProFceeTrendInfoObj : NSObject

@property (nonatomic, retain) ProFceeTrendObj       *trend_info_trend;
@property (nonatomic, retain) ProFceeUserObj        *trend_info_user;

- (ProFceeTrendInfoObj *)initWithDictionary:(NSDictionary *)dicTrendInfo;
- (NSDictionary *)currentDictionary;

@end
