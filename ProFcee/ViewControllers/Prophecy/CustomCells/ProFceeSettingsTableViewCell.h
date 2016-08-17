//
//  ProFceeSettingsTableViewCell.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/2/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProFceeSettingsTableViewCellDelegate <NSObject>

- (void)onSwitchValueChanged:(BOOL)isOn onIndexPath:(NSIndexPath *)indexPath;

@end

@interface ProFceeSettingsTableViewCell : UITableViewCell {
    NSIndexPath *m_indexPath;
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UISwitch *m_swtValue;

@property (nonatomic, retain) id<ProFceeSettingsTableViewCellDelegate> delegate;

- (void)setViewsWithDictionary:(NSDictionary *)dicSettings onIndexPath:(NSIndexPath *)indexPath;
- (IBAction)onSwitchValueChanged:(id)sender;

@end
