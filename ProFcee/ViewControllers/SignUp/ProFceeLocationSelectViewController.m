//
//  ProFceeLocationSelectViewController.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 7/30/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "ProFceeLocationSelectViewController.h"
#import "ProFceeLocationSelectTableViewCell.h"

@interface ProFceeLocationSelectViewController ()

@end

@implementation ProFceeLocationSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (self.m_typeLocation) {
        case LOCATION_COUNTRY:
            m_aryLocations = [GlobalService sharedInstance].user_countries;
            self.m_lblTitle.text = @"Select Your Country";
            break;
            
        case LOCATION_STATE:
            m_aryLocations = [GlobalService sharedInstance].user_states;
            self.m_lblTitle.text = @"Select Your State";
            break;
            
        case LOCATION_CITY:
            m_aryLocations = [GlobalService sharedInstance].user_cities;
            self.m_lblTitle.text = @"Select Your City";
            break;
    }
    
    if(self.m_typeLocation == LOCATION_COUNTRY) {
        m_strSelectedLocationName = [GlobalService sharedInstance].user_city.city_state.state_country.country_name;
    } else if(self.m_typeLocation == LOCATION_STATE) {
        m_strSelectedLocationName = [GlobalService sharedInstance].user_city.city_state.state_name;
    } else {
        m_strSelectedLocationName = [GlobalService sharedInstance].user_city.city_name;
    }
    
    [self searchLocationWithKey:@""];
    
    self.m_tblLocation.rowHeight = UITableViewAutomaticDimension;
    self.m_tblLocation.estimatedRowHeight = 44.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onClickBtnCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickBtnDone:(id)sender {
    switch (self.m_typeLocation) {
        case LOCATION_COUNTRY: {
            ProFceeCountryObj *objCountry = [[GlobalService sharedInstance] getCountryWithName:m_strSelectedLocationName];
            SVPROGRESSHUD_PLEASE_WAIT;
            [[WebService sharedInstance] getStatesWithCountryId:objCountry.country_id
                                                      Completed:^(NSArray *aryStates, NSString *strError) {
                                                          if(!strError) {
                                                              [GlobalService sharedInstance].user_states = aryStates;
                                                              ProFceeStateObj *objState = aryStates[0];
                                                              objState.state_country = objCountry;
                                                              
                                                              [self onChangeUserState:objState];
                                                              
                                                          } else {
                                                              SVPROGRESSHUD_ERROR(strError);
                                                          }
                                                      }];
            
            break;
        }
        case LOCATION_STATE: {
            ProFceeStateObj *objState = [[GlobalService sharedInstance] getStateWithName:m_strSelectedLocationName];
            objState.state_country = [GlobalService sharedInstance].user_city.city_state.state_country;
            
            SVPROGRESSHUD_PLEASE_WAIT;
            [self onChangeUserState:objState];
            
            break;
        }
        case LOCATION_CITY: {
            ProFceeCityObj *objCity = [[GlobalService sharedInstance] getCityWithName:m_strSelectedLocationName];
            objCity.city_state = [GlobalService sharedInstance].user_city.city_state;
            
            [self onChangeUserCity:objCity];
            
            break;
        }
    }
}

- (void)onChangeUserState:(ProFceeStateObj *)objState {
    [[WebService sharedInstance] getCitiesWithStateId:objState.state_id
                                            Completed:^(NSArray *aryCities, NSString *strError) {
                                                if(!strError) {
                                                    SVPROGRESSHUD_DISMISS;
                                                    
                                                    [GlobalService sharedInstance].user_cities = aryCities;
                                                    ProFceeCityObj *objCity = aryCities[0];
                                                    objCity.city_state = objState;
                                                    
                                                    [self onChangeUserCity:objCity];
                                                } else {
                                                    SVPROGRESSHUD_ERROR(strError);
                                                }
                                            }];
}

- (void)onChangeUserCity:(ProFceeCityObj *)objCity {
    [GlobalService sharedInstance].user_city = objCity;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_GOT_LOCATION object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchLocationWithKey:searchText];
}

- (void)searchLocationWithKey:(NSString *)key {
    m_aryTempLocations = [[NSMutableArray alloc] init];
    
    for(id objLocation in m_aryLocations) {
        NSString *strName = @"";
        if(self.m_typeLocation == LOCATION_COUNTRY) {
            strName = ((ProFceeCountryObj *)objLocation).country_name;
        } else if(self.m_typeLocation == LOCATION_STATE) {
            strName = ((ProFceeStateObj *)objLocation).state_name;
        } else {
            strName = ((ProFceeCityObj *)objLocation).city_name;
        }
        
        if(key.length == 0
           || [strName.lowercaseString containsString:key.lowercaseString]) {
            [m_aryTempLocations addObject:strName];
        }
    }
    
    [self.m_tblLocation reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_aryTempLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProFceeLocationSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProFceeLocationSelectTableViewCell class])];
    
    NSString *strLocationName = m_aryTempLocations[indexPath.row];
    cell.m_lblName.text = strLocationName;
    if([strLocationName isEqualToString:m_strSelectedLocationName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    m_strSelectedLocationName = m_aryTempLocations[indexPath.row];
    [tableView reloadData];
}

@end
