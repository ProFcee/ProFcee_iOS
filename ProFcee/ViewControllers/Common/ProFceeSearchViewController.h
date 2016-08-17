//
//  ProFceeSearchViewController.h
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 8/3/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProFceeTrendViewController.h"

@interface ProFceeSearchViewController : ProFceeTrendViewController {
    NSArray         *m_aryUsers;
    SEARCH_TYPE     m_typeSearch;
}

@property (weak, nonatomic) IBOutlet UITableView                *m_tblUser;
@property (weak, nonatomic) IBOutlet UISearchBar                *m_searchBar;

@property (weak, nonatomic) IBOutlet UIView                     *m_viewSearchHistory;
@property (weak, nonatomic) IBOutlet UITableView                *m_tblSearchHistory;
@property (weak, nonatomic) IBOutlet UIImageView                *m_imgNoSearch;
@property (weak, nonatomic) IBOutlet UILabel                    *m_lblSearchComment;

- (IBAction)onClickBtnCancel:(id)sender;
- (IBAction)onClickSearchKind:(id)sender;

@end
