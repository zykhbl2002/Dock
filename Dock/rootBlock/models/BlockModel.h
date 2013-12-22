//
//  BlockModel.h
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseModel.h"

@interface BlockModel : BaseModel {
    NSString *pk;
    NSString *addBlockPK;
    NSString *showType;
    NSString *blockTitle;
    NSString *apiURL;
    NSString *pic;
    NSString *tabinfoUrl;
    
    NSString *type;
    NSString *permissions;
    NSString *userId;
    NSString *screen_name;
    NSString *profile_image_url;
    NSString *code;
    NSString *accessToken;
    NSString *accessTokenSecret;
    int remindIn;//失效时间，单位s
    int loginInTime;//登陆时间，单位s
    
    NSString *loginName;
    NSString *loginPsd;
    NSString *openPsd;
    
    NSString *opendId;//qq
    NSString *country;//qq
    NSString *province;//qq
    NSString *city;//qq
}

@property (nonatomic, retain) NSString *pk;
@property (nonatomic, retain) NSString *addBlockPK;
@property (nonatomic, retain) NSString *showType;
@property (nonatomic, retain) NSString *blockTitle;
@property (nonatomic, retain) NSString *apiURL;
@property (nonatomic, retain) NSString *pic;
@property (nonatomic, retain) NSString *tabinfoUrl;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *permissions;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *screen_name;
@property (nonatomic, retain) NSString *profile_image_url;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *accessTokenSecret;
@property (nonatomic) int remindIn;
@property (nonatomic) int loginInTime;
@property (nonatomic, retain) NSString *loginName;
@property (nonatomic, retain) NSString *loginPsd;
@property (nonatomic, retain) NSString *openPsd;
@property (nonatomic, retain) NSString *opendId;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *province;
@property (nonatomic, retain) NSString *city;

- (BOOL)checkWbAccessTokenIsInvalid;

@end
