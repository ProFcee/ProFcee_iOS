//
//  ProFceeSettingsObj.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProFceeSettingsObj : NSObject

@property (nonatomic, readwrite) BOOL       settings_agree_post;
@property (nonatomic, readwrite) BOOL       settings_report_post;
@property (nonatomic, readwrite) BOOL       settings_share_post;
@property (nonatomic, readwrite) BOOL       settings_tell_prophicies;

@property (nonatomic, readwrite) BOOL       settings_update_features;
@property (nonatomic, readwrite) BOOL       settings_take_survey;
@property (nonatomic, readwrite) BOOL       settings_suggest_interesting;

@property (nonatomic, readwrite) BOOL       settings_suggest_typing;
@property (nonatomic, readwrite) BOOL       settings_spell_typing;

- (ProFceeSettingsObj *)initWithDictionary:(NSDictionary *)dicSettings;
- (NSDictionary *)currentDictionary;
- (NSArray *)arySettings;
- (void)setOn:(BOOL)isOn onIndexPath:(NSIndexPath *)indexPath;

@end
