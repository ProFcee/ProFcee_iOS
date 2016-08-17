//
//  ProFceeSettingsTableViewCell.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeSettingsTableViewCell.h"

@implementation ProFceeSettingsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setViewsWithDictionary:(NSDictionary *)dicSettings onIndexPath:(NSIndexPath *)indexPath {
    m_indexPath = indexPath;
    
    self.m_lblTitle.text = dicSettings[@"title"];
    self.m_swtValue.on = [dicSettings[@"value"] boolValue];
    
    self.m_lblTitle.textColor = [UIColor blackColor];
    self.m_swtValue.hidden = NO;
}

- (IBAction)onSwitchValueChanged:(id)sender {
    UISwitch *swtValue = (UISwitch *)sender;
    [self.delegate onSwitchValueChanged:swtValue.on onIndexPath:m_indexPath];
}

@end
