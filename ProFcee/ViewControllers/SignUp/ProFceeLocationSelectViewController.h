//
//  ProFceeLocationSelectViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/30/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LOCATION_COUNTRY = 0,
    LOCATION_STATE,
    LOCATION_CITY
}LOCATION_TYPE;

@interface ProFceeLocationSelectViewController : UIViewController {
    NSArray             *m_aryLocations;
    NSMutableArray      *m_aryTempLocations;
    
    NSString            *m_strSelectedLocationName;
}

@property (weak, nonatomic) IBOutlet UILabel        *m_lblTitle;
@property (weak, nonatomic) IBOutlet UISearchBar    *m_searchBar;
@property (weak, nonatomic) IBOutlet UITableView    *m_tblLocation;

@property (nonatomic, readwrite) LOCATION_TYPE      m_typeLocation;

- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickBtnDone:(id)sender;

@end
