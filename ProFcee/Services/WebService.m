//
//  WebService.m
//  ProFcee
//
//  Created by Dealyourself Internet Private Limited on 4/10/16.
//  Copyright © 2016 Dealyourself Internet Private Limited. All rights reserved.
//

#import "WebService.h"
#import <AFNetworking/AFNetworking.h>

@implementation WebService

static WebService *_webService = nil;
AFHTTPSessionManager *manager;

+ (WebService *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_webService == nil) {
            _webService = [[self alloc] init]; // assignment not done here
            
            manager = [AFHTTPSessionManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"image/jpeg", nil];
            
            if([GlobalService sharedInstance].user_me) {
                [manager.requestSerializer setValue:[GlobalService sharedInstance].user_me.my_access_token
                                 forHTTPHeaderField:HTTP_HEADER_ACCESS_TOKEN];
            }
        }
    });
    
    return _webService;
}

- (void)profceeDomain:(void (^)(NSString *strProfceeDomain, NSString *error))completed {
    if(!self.m_strProfceeDomain) {
        [manager GET:IP_FETCH_DOMAIN_ADDRESS
          parameters:nil
            progress:nil
             success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                 NSString *strDomain = [responseObject[@"targetservers"][@"profcee"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                 self.m_strProfceeDomain = [NSString stringWithFormat:@"http://%@/api/v2", strDomain];
                 if(completed) {
                     completed(self.m_strProfceeDomain, nil);
                 }
             }
             failure:^(NSURLSessionDataTask *task, NSError *error) {
                 if(completed) {
                     completed(nil, error.localizedDescription);
                 }
             }];
    } else {
        if(completed) {
            completed(self.m_strProfceeDomain, nil);
        }
    }
}

- (NSString *)getErrorMessageFromNSError:(NSError *)error {
    NSData *errorData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if(errorData && errorData.length > 0) {
        NSDictionary *dicError = [NSJSONSerialization JSONObjectWithData:errorData
                                                                 options:0
                                                                   error:nil];
        return dicError[SERVER_RESPONSE_MESSAGE];
    } else {
        return error.localizedDescription;
    }
}

- (NSInteger)getErrorCodeFromNSError:(NSError *)error {
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    return response.statusCode;
}

- (void)GET:(NSString *)URLString
 parameters:(id)parameters
  completed:(void (^)(id, NSString *))completed {
    if([GlobalService sharedInstance].is_internet_alive) {
        [self profceeDomain:^(NSString *strProfceeDomain, NSString *error) {
            if(!error) {
                NSString *url = [NSString stringWithFormat:@"%@/%@", strProfceeDomain, URLString];
                
                [manager GET:url
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         completed(responseObject, nil);
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if([self getErrorCodeFromNSError:error] == SERVER_RESPONSE_UNAUTHENTICATE_CODE) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_TOKEN_EXPIRED object:nil];
                         }
                         completed(nil, [self getErrorMessageFromNSError:error]);
                     }];
            } else {
                completed(nil, error);
            }
        }];
    } else {
        completed(nil, STRING_NO_INTERNET);
    }
}

- (void)PUT:(NSString *)URLString
 parameters:(nullable id)parameters
  completed:(void (^)(id, NSString *))completed {
    if([GlobalService sharedInstance].is_internet_alive) {
        [self profceeDomain:^(NSString *strProfceeDomain, NSString *error) {
            if(!error) {
                NSString *url = [NSString stringWithFormat:@"%@/%@", strProfceeDomain, URLString];
                
                [manager PUT:url
                  parameters:parameters
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         completed(responseObject, nil);
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if([self getErrorCodeFromNSError:error] == SERVER_RESPONSE_UNAUTHENTICATE_CODE) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_TOKEN_EXPIRED object:nil];
                         }
                         completed(nil, [self getErrorMessageFromNSError:error]);
                     }];
            } else {
                completed(nil, error);
            }
        }];
    } else {
        completed(nil, STRING_NO_INTERNET);
    }
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
   completed:(void (^)(id, NSString *))completed {
    if([GlobalService sharedInstance].is_internet_alive) {
        [self profceeDomain:^(NSString *strProfceeDomain, NSString *error) {
            if(!error) {
                NSString *url = [NSString stringWithFormat:@"%@/%@", strProfceeDomain, URLString];
                
                [manager POST:url
                   parameters:parameters
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          completed(responseObject, nil);
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if([self getErrorCodeFromNSError:error] == SERVER_RESPONSE_UNAUTHENTICATE_CODE) {
                              [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_TOKEN_EXPIRED object:nil];
                          }
                          completed(nil, [self getErrorMessageFromNSError:error]);
                      }];
            } else {
                completed(nil, error);
            }
        }];
    } else {
        completed(nil, STRING_NO_INTERNET);
    }
}

- (void)POST:(NSString *)URLString
  parameters:(id)parameters
constructingBodyWithBolock:(void (^)(id <AFMultipartFormData>))constructingBody
    progress:(void (^)(NSProgress *))uploadProgress
   completed:(void (^)(id, NSString *))completed {
    if([GlobalService sharedInstance].is_internet_alive) {
        [self profceeDomain:^(NSString *strProfceeDomain, NSString *error) {
            if(!error) {
                NSString *url = [NSString stringWithFormat:@"%@/%@", strProfceeDomain, URLString];
                
                [manager POST:url
                   parameters:parameters
    constructingBodyWithBlock:constructingBody
                     progress:uploadProgress
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          completed(responseObject, nil);
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if([self getErrorCodeFromNSError:error] == SERVER_RESPONSE_UNAUTHENTICATE_CODE) {
                              [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_TOKEN_EXPIRED object:nil];
                          }
                          completed(nil, [self getErrorMessageFromNSError:error]);
                      }];
            } else {
                completed(nil, error);
            }
        }];
    } else {
        completed(nil, STRING_NO_INTERNET);
    }
}

- (void)PATCH:(NSString *)URLString
   parameters:(id)parameters
    completed:(void (^)(id, NSString *))completed {
    if([GlobalService sharedInstance].is_internet_alive) {
        [self profceeDomain:^(NSString *strProfceeDomain, NSString *error) {
            if(!error) {
                NSString *url = [NSString stringWithFormat:@"%@/%@", strProfceeDomain, URLString];
                
                [manager PATCH:url
                    parameters:parameters
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           completed(responseObject, nil);
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           if([self getErrorCodeFromNSError:error] == SERVER_RESPONSE_UNAUTHENTICATE_CODE) {
                               [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_TOKEN_EXPIRED object:nil];
                           }
                           completed(nil, [self getErrorMessageFromNSError:error]);
                       }];
            } else {
                completed(nil, error);
            }
        }];
    } else {
        completed(nil, STRING_NO_INTERNET);
    }
}

- (void)DELETE:(NSString *)URLString
    parameters:(id)parameters
     completed:(void (^)(id, NSString *))completed {
    if([GlobalService sharedInstance].is_internet_alive) {
        [self profceeDomain:^(NSString *strProfceeDomain, NSString *error) {
            if(!error) {
                NSString *url = [NSString stringWithFormat:@"%@/%@", strProfceeDomain, URLString];
                
                [manager DELETE:url
                     parameters:parameters
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            completed(responseObject, nil);
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            if([self getErrorCodeFromNSError:error] == SERVER_RESPONSE_UNAUTHENTICATE_CODE) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NOTIFICATION_TOKEN_EXPIRED object:nil];
                            }
                            completed(nil, [self getErrorMessageFromNSError:error]);
                        }];
            } else {
                completed(nil, error);
            }
        }];
    } else {
        completed(nil, STRING_NO_INTERNET);
    }
}

#pragma mark - User
- (void)signUpUserWithEmail:(NSString *)email
                   UserName:(NSString *)name
                   Password:(NSString *)password
                  Completed:(void (^)(ProFceeUserMe *, NSString *))completed {
    
    NSDictionary *dicParams = @{
                                @"user_email":          email,
                                @"user_name":           name,
                                @"user_pass":           password,
                                @"user_device_token":   [GlobalService sharedInstance].device_token,
                                @"user_device_type":    @"iOS"
                                };
    
    [self POST:@"users"
    parameters:dicParams
     completed:^(NSDictionary *dicUserMe, NSString *strError) {
         if(!strError) {
             ProFceeUserMe *objMe = [[ProFceeUserMe alloc] initWithDictionary:dicUserMe];
             
             //add token to header
             [manager.requestSerializer setValue:objMe.my_access_token
                              forHTTPHeaderField:HTTP_HEADER_ACCESS_TOKEN];
             
             completed(objMe, nil);
         } else {
             completed(nil, strError);
         }
     }];
}

- (void)socialLoginWithEmail:(NSString *)email
                        Name:(NSString *)name
                    Password:(NSString *)password
                ProfileImage:(NSString *)avatar_url
                   Completed:(void (^)(ProFceeUserMe *, NSString *))completed {
    
    NSDictionary *dicParams = @{
                                @"user_email":          email,
                                @"user_name":           name,
                                @"user_pass":           password,
                                @"user_avatar_url":     avatar_url,
                                @"user_device_token":   [GlobalService sharedInstance].device_token,
                                @"user_device_type":    @"iOS"
                                };
    
    [self POST:@"users/social"
    parameters:dicParams
     completed:^(NSDictionary *dicUserMe, NSString *strError) {
         if(!strError) {
             ProFceeUserMe *objMe = [[ProFceeUserMe alloc] initWithDictionary:dicUserMe];
             
             //add token to header
             [manager.requestSerializer setValue:objMe.my_access_token
                              forHTTPHeaderField:HTTP_HEADER_ACCESS_TOKEN];
             
             completed(objMe, nil);
         } else {
             completed(nil, strError);
         }
     }];
}

- (void)loginUserWithEmail:(NSString *)email
                  Password:(NSString *)password
                 Completed:(void (^)(ProFceeUserMe *objMe, NSString *strError))completed {
    
    NSDictionary *dicParams = @{
                                @"user_email":          email,
                                @"user_pass":           password,
                                @"user_device_token":   [GlobalService sharedInstance].device_token,
                                @"user_device_type":    @"iOS"
                                };
    
    [self POST:@"users/auth"
    parameters:dicParams
     completed:^(NSDictionary *dicUserMe, NSString *strError) {
         if(!strError) {
             ProFceeUserMe *objMe = [[ProFceeUserMe alloc] initWithDictionary:dicUserMe];
             
             //add token to header
             [manager.requestSerializer setValue:objMe.my_access_token
                              forHTTPHeaderField:HTTP_HEADER_ACCESS_TOKEN];
             
             completed(objMe, nil);
         } else {
             completed(nil, strError);
         }
     }];
}

- (void)forgotPasswordWithEmail:(NSString *)email
                      Completed:(void (^)(NSString *, NSString *))completed {
    [self GET:@"users/forgot/password"
   parameters:@{@"user_email": email}
    completed:^(NSDictionary *dicResult, NSString *strError) {
        if(!strError) {
            completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)resetPasswordWithCode:(NSString *)code
                  NewPassword:(NSString *)password
                    Completed:(void (^)(NSString *, NSString *))completed {
    NSDictionary *dicParams = @{
                                @"code":      code,
                                @"user_pass": password
                                };
    [self PATCH:@"users/reset/password"
     parameters:dicParams
      completed:^(NSDictionary *dicResult, NSString *strError) {
          if(!strError) {
              completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
          } else {
              completed(nil, strError);
          }
      }];
}

- (void)updatePasswordWithCurrentPassword:(NSString *)current_pass
                              NewPassword:(NSString *)new_pass
                                Completed:(void (^)(NSString *, NSString *))completed {
    NSDictionary *dicParams = @{
                                @"current_pass":    current_pass,
                                @"new_pass":        new_pass
                                };
    [self PATCH:@"users/update/password"
     parameters:dicParams
      completed:^(NSDictionary *dicResult, NSString *strError) {
          if(!strError) {
              completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
          } else {
              completed(nil, strError);
          }
      }];
}

- (void)logoutUserWithId:(NSNumber *)user_id
               Completed:(void (^)(NSString *, NSString *))completed {
    [self DELETE:[NSString stringWithFormat:@"users/%d/logout", user_id.intValue]
      parameters:nil
       completed:^(NSString *strResult, NSString *strError) {
           if(!strError) {
               //remove token from header
               [manager.requestSerializer setValue:nil
                                forHTTPHeaderField:HTTP_HEADER_ACCESS_TOKEN];
               
               completed(strResult, nil);
           } else {
               completed(nil, strError);
           }
       }];
}

- (void)updateUserWithUserObj:(ProFceeUserObj *)objUser
                 ProfileImage:(UIImage *)imgAvatar
                  BannerImage:(UIImage *)imgBanner
                     Progress:(void (^)(double))progress
                    Completed:(void (^)(ProFceeUserObj *, NSString *))completed {
    [self POST:@"users/update"
    parameters:objUser.currentDictionary
constructingBodyWithBolock:^(id<AFMultipartFormData> formData) {
    if(imgAvatar) {
        [formData appendPartWithFileData:[NSData dataWithData:UIImageJPEGRepresentation(imgAvatar, 0.5f)]
                                    name:@"avatar"
                                fileName:@"avatar.jpg"
                                mimeType:@"image/jpeg"];
    }
    
    if(imgBanner) {
        [formData appendPartWithFileData:[NSData dataWithData:UIImageJPEGRepresentation(imgBanner, 0.5f)]
                                    name:@"banner"
                                fileName:@"banner.jpg"
                                mimeType:@"image/jpeg"];
    }
}
      progress:^(NSProgress *uploadedProgress) {
          progress(uploadedProgress.fractionCompleted);
      }
     completed:^(NSDictionary *dicUserObj, NSString *strError) {
         if(!strError) {
             ProFceeUserObj *objUser = [[ProFceeUserObj alloc] initWithDictionary:dicUserObj];
             completed(objUser, nil);
         } else {
             completed(nil, strError);
         }
     }];
}

- (void)deactivateUser:(void (^)(NSString *, NSString *))completed {
    [self PATCH:@"users/deactivate"
     parameters:nil
      completed:^(NSDictionary *dicResult, NSString *strError) {
          if(!strError) {
              completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
          } else {
              completed(nil, strError);
          }
      }];
}

- (void)getUserTrends:(NSNumber *)user_id
            Completed:(void (^)(NSArray *, NSString *))completed {
    [self GET:[NSString stringWithFormat:@"users/%d/trends", user_id.intValue]
   parameters:nil
    completed:^(NSArray *aryDicTrendInfos, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryTrendInfos = [[NSMutableArray alloc] init];
            for(NSDictionary *dicTrendInfo in aryDicTrendInfos) {
                ProFceeTrendInfoObj *objTrendInfo = [[ProFceeTrendInfoObj alloc] initWithDictionary:dicTrendInfo];
                [aryTrendInfos addObject:objTrendInfo];
            }
            
            completed(aryTrendInfos, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)getUserAgreedTrends:(NSNumber *)user_id
                  Completed:(void (^)(NSArray *, NSString *))completed {
    [self GET:[NSString stringWithFormat:@"users/%d/agreed/trends", user_id.intValue]
   parameters:nil
    completed:^(NSArray *aryDicTrendInfos, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryTrendInfos = [[NSMutableArray alloc] init];
            for(NSDictionary *dicTrendInfo in aryDicTrendInfos) {
                ProFceeTrendInfoObj *objTrendInfo = [[ProFceeTrendInfoObj alloc] initWithDictionary:dicTrendInfo];
                [aryTrendInfos addObject:objTrendInfo];
            }
            
            completed(aryTrendInfos, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

#pragma mark - Location
- (void)getCountries:(void (^)(NSArray *, NSString *))completed {
    [self GET:@"countries"
   parameters:nil
    completed:^(NSArray *aryDicCountries, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryCountries = [[NSMutableArray alloc] init];
            for(NSDictionary *dicCountry in aryDicCountries) {
                ProFceeCountryObj *objCountry = [[ProFceeCountryObj alloc] initWithDictionary:dicCountry];
                [aryCountries addObject:objCountry];
            }
            
            completed(aryCountries, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)getStatesWithCountryId:(NSNumber *)country_id Completed:(void (^)(NSArray *, NSString *))completed {
    [self GET:@"states"
   parameters:@{@"country_id": country_id}
    completed:^(NSArray *aryDicStates, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryStates = [[NSMutableArray alloc] init];
            for(NSDictionary *dicState in aryDicStates) {
                ProFceeStateObj *objState = [[ProFceeStateObj alloc] initWithDictionary:dicState];
                [aryStates addObject:objState];
            }
            
            completed(aryStates, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)getCitiesWithStateId:(NSNumber *)state_id Completed:(void (^)(NSArray *, NSString *))completed {
    [self GET:@"cities"
   parameters:@{@"state_id": state_id}
    completed:^(NSArray *aryDicCities, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryCities = [[NSMutableArray alloc] init];
            for(NSDictionary *dicCity in aryDicCities) {
                ProFceeCityObj *objCity = [[ProFceeCityObj alloc] initWithDictionary:dicCity];
                [aryCities addObject:objCity];
            }
            
            completed(aryCities, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

#pragma mark - Trend
- (void)createNewTrend:(NSString *)trend_body
                 Image:(UIImage *)trend_image
              Progress:(void (^)(double))progress
             Completed:(void (^)(NSString *, NSString *))completed {
    NSDictionary *dicParams = @{
                                @"trend_body":  trend_body
                                };
    
    [self POST:@"trends"
    parameters:dicParams
constructingBodyWithBolock:^(id<AFMultipartFormData> formData) {
    if(trend_image) {
        [formData appendPartWithFileData:[NSData dataWithData:UIImageJPEGRepresentation(trend_image, 0.5f)]
                                    name:@"trend"
                                fileName:@"trend.jpg"
                                mimeType:@"image/jpeg"];
    }
}
      progress:^(NSProgress *uploadedProgress) {
          progress(uploadedProgress.fractionCompleted);
      }
     completed:^(NSDictionary *dicResult, NSString *strError) {
         if(!strError) {
             completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
         } else {
             completed(nil, strError);
         }
     }];
}

- (void)getTrendByType:(TREND_TYPE)type
             Completed:(void (^)(NSArray *aryTrendInfos, NSString *strError))completed {
    NSString *strUrl;
    switch (type) {
        case TREND_NORMAL:
            strUrl = @"trends";
            break;
            
        case TREND_NORMAL_TOP_RATED:
            strUrl = @"trends/guest/toprated";
            break;
            
        case TREND_PICK:
            strUrl = @"trends/picks";
            break;
            
        case TREND_USER_TOP_RATED:
            strUrl = @"trends/toprated";
            break;
    }
    
    [self GET:strUrl
   parameters:nil
    completed:^(NSArray *aryDicTrendInfos, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryTrendInfos = [[NSMutableArray alloc] init];
            for(NSDictionary *dicTrendInfo in aryDicTrendInfos) {
                ProFceeTrendInfoObj *objTrendInfo = [[ProFceeTrendInfoObj alloc] initWithDictionary:dicTrendInfo];
                [aryTrendInfos addObject:objTrendInfo];
            }
            
            completed(aryTrendInfos, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)agreeTrend:(NSNumber *)trend_id
         Completed:(void (^)(NSString *, NSString *))completed {
    [self PATCH:[NSString stringWithFormat:@"trends/%d/agree", trend_id.intValue]
     parameters:nil
      completed:^(NSDictionary *dicResult, NSString *strError) {
          if(!strError) {
              completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
          } else {
              completed(nil, strError);
          }
      }];
}

- (void)shareTrend:(NSNumber *)trend_id
         Completed:(void (^)(NSString *, NSString *))completed {
    [self PATCH:[NSString stringWithFormat:@"trends/%d/share", trend_id.intValue]
     parameters:nil
      completed:^(NSDictionary *dicResult, NSString *strError) {
          if(!strError) {
              completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
          } else {
              completed(nil, strError);
          }
      }];
}

- (void)reportTrend:(NSNumber *)trend_id
          Completed:(void (^)(NSString *, NSString *))completed {
    [self PATCH:[NSString stringWithFormat:@"trends/%d/report", trend_id.intValue]
     parameters:nil
      completed:^(NSDictionary *dicResult, NSString *strError) {
          if(!strError) {
              completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
          } else {
              completed(nil, strError);
          }
      }];
}

- (void)getTrendAgrees:(NSNumber *)trend_id
             Completed:(void (^)(NSArray *, NSString *))completed {
    [self GET:[NSString stringWithFormat:@"trends/%d/agrees", trend_id.intValue]
   parameters:nil
    completed:^(NSArray *aryDicUserInfos, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryUserInfos = [[NSMutableArray alloc] init];
            for(NSDictionary *dicUserInfo in aryDicUserInfos) {
                ProFceeUserInfoObj *objUserInfo = [[ProFceeUserInfoObj alloc] initWithDictionary:dicUserInfo];
                [aryUserInfos addObject:objUserInfo];
            }
            completed(aryUserInfos, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)deleteTrend:(NSNumber *)trend_id
          Completed:(void (^)(NSString *, NSString *))completed {
    [self DELETE:[NSString stringWithFormat:@"trends/%d", trend_id.intValue]
      parameters:nil
       completed:^(NSDictionary *dicResult, NSString *strError) {
           if(!strError) {
               completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
           } else {
               completed(nil, strError);
           }
       }];
}

#pragma mark - Notification
- (void)getUserNotifications:(void (^)(NSArray *aryNotifications, NSString *strError))completed {
    [self GET:@"notifications"
   parameters:nil
    completed:^(NSArray *aryDicNotifications, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryNotfications = [[NSMutableArray alloc] init];
            for(NSDictionary *dicNotification in aryDicNotifications) {
                ProFceeNotificationObj *objNotification = [[ProFceeNotificationObj alloc] initWithDictionary:dicNotification];
                [aryNotfications addObject:objNotification];
            }
            
            completed(aryNotfications, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)markNotificationsAsRead:(void (^)(NSString *, NSString *))completed {
    [self PATCH:@"notifications"
     parameters:nil
      completed:^(NSDictionary *dicResult, NSString *strError) {
          if(!strError) {
              completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
          } else {
              completed(nil, strError);
          }
      }];
}

- (void)clearUserNotifications:(void (^)(NSString *, NSString *))completed {
    [self DELETE:@"notifications"
      parameters:nil
       completed:^(NSDictionary *dicResult, NSString *strError) {
           if(!strError) {
               completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
           } else {
               completed(nil, strError);
           }
       }];
}

- (void)getNotificationWithId:(NSNumber *)notification_id
                    Completed:(void (^)(ProFceeNotificationObj *, NSString *))completed {
    [self GET:[NSString stringWithFormat:@"notifications/%d", notification_id.intValue]
   parameters:nil
    completed:^(NSDictionary *dicNotification, NSString *strError) {
        if(!strError) {
            ProFceeNotificationObj *objNotification = [[ProFceeNotificationObj alloc] initWithDictionary:dicNotification];
            completed(objNotification, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)removeNotificationWithId:(NSNumber *)notification_id
                       Completed:(void (^)(NSString *, NSString *))completed {
    [self DELETE:[NSString stringWithFormat:@"notifications/%d", notification_id.intValue]
      parameters:nil
       completed:^(NSDictionary *dicResult, NSString *strError) {
           if(!strError) {
               completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
           } else {
               completed(nil, strError);
           }
       }];
}

#pragma mark - Settings
- (void)getUserSettings:(void (^)(ProFceeSettingsObj *, NSString *))completed {
    [self GET:@"settings"
   parameters:nil
    completed:^(NSDictionary *dicSettings, NSString *strError) {
        if(!strError) {
            ProFceeSettingsObj *objSettings = [[ProFceeSettingsObj alloc] initWithDictionary:dicSettings];
            completed(objSettings, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)updateUserSettings:(ProFceeSettingsObj *)objSettings
                 Completed:(void (^)(NSString *, NSString *))completed {
    [self PUT:@"settings"
   parameters:objSettings.currentDictionary
    completed:^(NSDictionary *dicResult, NSString *strError) {
        if(!strError) {
            completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
        } else {
            completed(nil, strError);
        }
    }];
}

#pragma mark - Message
- (void)createChatRoom:(NSArray *)user_ids
               TrendId:(NSNumber *)trend_id
               Message:(NSString *)message
             Completed:(void (^)(NSString *, NSString *))completed {
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:user_ids
                                                       options:0
                                                         error:&error];
    
    NSString *strJSONUserIds = @"";
    
    if (!jsonData) {
        NSLog(@"JSON error: %@", error);
    } else {
        strJSONUserIds = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    }
    
    NSDictionary *dicParams = @{
                                @"user_ids":    strJSONUserIds,
                                @"trend_id":    trend_id,
                                @"message":     message
                                };
    [self POST:@"messages"
    parameters:dicParams
     completed:^(NSDictionary *dicResult, NSString *strError) {
         if(!strError) {
             completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
         } else {
             completed(nil, strError);
         }
     }];
}

- (void)getChatrooms:(void (^)(NSArray *, NSString *))completed {
    [self GET:@"messages/chatrooms"
   parameters:nil
    completed:^(NSArray *aryDicChatRoom, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryChatRooms = [[NSMutableArray alloc] init];
            for(NSDictionary *dicChatRoom in aryDicChatRoom) {
                ProFceeChatRoomObj *objChatRoom = [[ProFceeChatRoomObj alloc] initWithDictionary:dicChatRoom];
                [aryChatRooms addObject:objChatRoom];
            }
            
            completed(aryChatRooms, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)getAllRepliesWithConversationId:(NSNumber *)conversation_id
                              Completed:(void (^)(NSArray *, NSString *))completed {
    [self GET:[NSString stringWithFormat:@"messages/%@", conversation_id]
     parameters:nil
    completed:^(NSArray *aryDicReplies, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryReplies = [[NSMutableArray alloc] init];
            for(NSDictionary *dicReply in aryDicReplies) {
                ProFceeReplyObj *objReply = [[ProFceeReplyObj alloc] initWithDictionary:dicReply];
                [aryReplies addObject:objReply];
            }
            
            completed(aryReplies, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)deleteConversation:(NSNumber *)conversation_id
                 Completed:(void (^)(NSString *, NSString *))completed {
    [self DELETE:[NSString stringWithFormat:@"messages/%d", conversation_id.intValue]
      parameters:nil
       completed:^(NSDictionary *dicResult, NSString *strError) {
           if(!strError) {
               completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
           } else {
               completed(nil, strError);
           }
       }];
}

- (void)blockChatroomWithConversationId:(NSNumber *)conversation_id
                               UserName:(NSString *)user_name
                              Completed:(void (^)(NSString *, NSString *))completed {
    NSDictionary *dicParams = @{
                                @"user_name": user_name
                                };
    
    [self PATCH:[NSString stringWithFormat:@"messages/%@/block", conversation_id]
     parameters:dicParams
      completed:^(NSDictionary *dicResult, NSString *strError) {
          if(!strError) {
              completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
          } else {
              completed(nil, strError);
          }
      }];
}

- (void)sendReplyWithConversationId:(NSNumber *)conversation_id
                            Message:(NSString *)message
                           UserName:(NSString *)user_name
                          Completed:(void (^)(NSString *, NSString *))completed {
    NSDictionary *dicParams = @{
                                @"message":    message,
                                @"user_name":   user_name
                                };
    
    [self POST:[NSString stringWithFormat:@"messages/%@", conversation_id]
     parameters:dicParams
      completed:^(NSDictionary *dicResult, NSString *strError) {
          if(!strError) {
              completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
          } else {
              completed(nil, strError);
          }
      }];
}

- (void)getReplyById:(NSNumber *)reply_id
           Completed:(void (^)(ProFceeReplyObj *, NSString *))completed {
    [self GET:[NSString stringWithFormat:@"messages/reply/%d", reply_id.intValue]
   parameters:nil
    completed:^(NSDictionary *dicReply, NSString *strError) {
        if(!strError) {
            ProFceeReplyObj *objReply = [[ProFceeReplyObj alloc] initWithDictionary:dicReply];
            completed(objReply, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

- (void)deleteReply:(NSNumber *)reply_id
          Completed:(void (^)(NSString *, NSString *))completed {
    [self DELETE:[NSString stringWithFormat:@"messages/reply/%d", reply_id.intValue]
      parameters:nil
       completed:^(NSDictionary *dicResult, NSString *strError) {
           if(!strError) {
               completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
           } else {
               completed(nil, strError);
           }
       }];
}

- (void)markReplyAsRead:(NSNumber *)reply_id
              Completed:(void (^)(NSString *, NSString *))completed {
    [self PATCH:[NSString stringWithFormat:@"messages/reply/%d", reply_id.intValue]
     parameters:nil
      completed:^(NSDictionary *dicResult, NSString *strError) {
           if(!strError) {
               completed(dicResult[SERVER_RESPONSE_MESSAGE], nil);
           } else {
               completed(nil, strError);
           }
       }];
}

#pragma mark - Search
- (void)searchKeyword:(NSString *)keyword
             WithKind:(SEARCH_TYPE)type
            Completed:(void (^)(NSArray *, NSString *))completed {
    
    NSDictionary *dicParams = @{
                                @"keyword":     keyword,
                                @"type":        [NSNumber numberWithInt:type]
                                };
    
    [self GET:@"search"
   parameters:dicParams
    completed:^(NSArray *aryDicResult, NSString *strError) {
        if(!strError) {
            NSMutableArray *aryResult = [[NSMutableArray alloc] init];
            
            if(type == SEARCH_USER_BY_NAME
               || type == SEARCH_USER_BY_EMAIL) {
                for(NSDictionary *dicUserInfo in aryDicResult) {
                    ProFceeUserInfoObj *objUserInfo = [[ProFceeUserInfoObj alloc] initWithDictionary:dicUserInfo];
                    [aryResult addObject:objUserInfo];
                }
            } else {
                for(NSDictionary *dicTrendInfo in aryDicResult) {
                    ProFceeTrendInfoObj *objTrendInfo = [[ProFceeTrendInfoObj alloc] initWithDictionary:dicTrendInfo];
                    [aryResult addObject:objTrendInfo];
                }
            }
            
            completed(aryResult, nil);
        } else {
            completed(nil, strError);
        }
    }];
}

@end
