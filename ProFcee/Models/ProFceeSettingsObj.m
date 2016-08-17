//
//  ProFceeSettingsObj.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeSettingsObj.h"

@implementation ProFceeSettingsObj

- (id)init {
    self = [super init];
    if(self) {
        self.settings_agree_post = NO;
        self.settings_share_post = NO;
        self.settings_report_post = NO;
        self.settings_tell_prophicies = NO;
        
        self.settings_update_features = NO;
        self.settings_take_survey = NO;
        self.settings_suggest_interesting = NO;
        
        self.settings_suggest_typing = NO;
        self.settings_spell_typing = NO;
    }
    
    return self;
}

- (ProFceeSettingsObj *)initWithDictionary:(NSDictionary *)dicSettings {
    ProFceeSettingsObj *objSettings = [[ProFceeSettingsObj alloc] init];
    
    if(dicSettings[@"agree_post"] && ![dicSettings[@"agree_post"] isEqual:[NSNull null]]) {
        objSettings.settings_agree_post = [dicSettings[@"agree_post"] boolValue];
    }
    
    if(dicSettings[@"shares"] && ![dicSettings[@"shares"] isEqual:[NSNull null]]) {
        objSettings.settings_share_post = [dicSettings[@"shares"] boolValue];
    }
    
    if(dicSettings[@"reports"] && ![dicSettings[@"reports"] isEqual:[NSNull null]]) {
        objSettings.settings_report_post = [dicSettings[@"reports"] boolValue];
    }
    
    if(dicSettings[@"toprated"] && ![dicSettings[@"toprated"] isEqual:[NSNull null]]) {
        objSettings.settings_tell_prophicies = [dicSettings[@"toprated"] boolValue];
    }
    
    if(dicSettings[@"new_products"] && ![dicSettings[@"new_products"] isEqual:[NSNull null]]) {
        objSettings.settings_update_features = [dicSettings[@"new_products"] boolValue];
    }
    
    if(dicSettings[@"participation"] && ![dicSettings[@"participation"] isEqual:[NSNull null]]) {
        objSettings.settings_take_survey = [dicSettings[@"participation"] boolValue];
    }
    
    if(dicSettings[@"interesting"] && ![dicSettings[@"interesting"] isEqual:[NSNull null]]) {
        objSettings.settings_suggest_interesting = [dicSettings[@"interesting"] boolValue];
    }
    
    if(dicSettings[@"use_word"] && ![dicSettings[@"use_word"] isEqual:[NSNull null]]) {
        objSettings.settings_suggest_typing = [dicSettings[@"use_word"] boolValue];
    }
    
    if(dicSettings[@"use_spell"] && ![dicSettings[@"use_spell"] isEqual:[NSNull null]]) {
        objSettings.settings_spell_typing = [dicSettings[@"use_spell"] boolValue];
    }
    
    return objSettings;
}

- (NSDictionary *)currentDictionary {
    return @{
             @"agree_post":     [NSNumber numberWithBool:self.settings_agree_post],
             @"shares":         [NSNumber numberWithBool:self.settings_share_post],
             @"reports":        [NSNumber numberWithBool:self.settings_report_post],
             @"toprated":       [NSNumber numberWithBool:self.settings_tell_prophicies],
             @"new_products":   [NSNumber numberWithBool:self.settings_update_features],
             @"participation":  [NSNumber numberWithBool:self.settings_take_survey],
             @"interesting":    [NSNumber numberWithBool:self.settings_suggest_interesting],
             @"use_word":       [NSNumber numberWithBool:self.settings_suggest_typing],
             @"use_spell":      [NSNumber numberWithBool:self.settings_spell_typing]
             };
}

- (NSArray *)arySettings {
    return @[
             @[
                 @{@"title": @"Someone agrees to your post", @"value": [NSNumber numberWithBool:self.settings_agree_post]},
                 @{@"title": @"Someone reports your post", @"value": [NSNumber numberWithBool:self.settings_report_post]},
                 @{@"title": @"Someone shares your post", @"value": [NSNumber numberWithBool:self.settings_share_post]},
                 @{@"title": @"Tell me about Prophecies", @"value": [NSNumber numberWithBool:self.settings_tell_prophicies]}
                 ],
             @[
                 @{@"title": @"Updates about new features", @"value": [NSNumber numberWithBool:self.settings_update_features]},
                 @{@"title": @"Help us improve. Take Survey", @"value": [NSNumber numberWithBool:self.settings_take_survey]},
                 @{@"title": @"Suggestions on interesting posts", @"value": [NSNumber numberWithBool:self.settings_suggest_interesting]}
                 ],
             @[
                 @{@"title": @"Use word suggestions while typing", @"value": [NSNumber numberWithBool:self.settings_suggest_typing]},
                 @{@"title": @"Use spell checking while typing", @"value": [NSNumber numberWithBool:self.settings_spell_typing]}
                 ]
             ];
}

- (void)setOn:(BOOL)isOn onIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            self.settings_agree_post = isOn;
        } else if(indexPath.row == 1) {
            self.settings_report_post = isOn;
        } else if(indexPath.row == 2) {
            self.settings_share_post = isOn;
        } else {
            self.settings_tell_prophicies = isOn;
        }
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            self.settings_update_features = isOn;
        } else if(indexPath.row == 1) {
            self.settings_take_survey = isOn;
        } else {
            self.settings_suggest_interesting = isOn;
        }
    } else {
        if(indexPath.row == 0) {
            self.settings_suggest_typing = isOn;
        } else {
            self.settings_spell_typing = isOn;
        }
    }
    
    [[GlobalService sharedInstance] saveMe];
}

@end
