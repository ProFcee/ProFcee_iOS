//
//  ProFceeMessageViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 18/07/2016.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProFceeTrendViewController.h"

@interface ProFceeMessageViewController : ProFceeTrendViewController<UIAlertViewDelegate> {
    NSMutableArray  *m_aryChatRooms;
    NSMutableArray  *m_aryTmpChatRooms;
}

@property (weak, nonatomic) IBOutlet UITableView        *m_tblChatRooms;
@property (weak, nonatomic) IBOutlet UISegmentedControl *m_segKind;
@property (weak, nonatomic) IBOutlet UIView             *m_viewNoMessage;

- (IBAction)onChangedSegment:(id)sender;

@end
