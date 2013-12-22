//
//  BlockModel.m
//  WBHui
//
//  Created by kenny on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockModel.h"

@implementation BlockModel

@synthesize pk;
@synthesize addBlockPK;
@synthesize showType;
@synthesize blockTitle;
@synthesize apiURL;
@synthesize pic;
@synthesize type;
@synthesize permissions;
@synthesize tabinfoUrl;
@synthesize userId;
@synthesize screen_name;
@synthesize profile_image_url;
@synthesize code;
@synthesize accessToken;
@synthesize accessTokenSecret;
@synthesize remindIn;
@synthesize loginInTime;
@synthesize loginName;
@synthesize loginPsd;
@synthesize openPsd;
@synthesize opendId;
@synthesize country;
@synthesize province;
@synthesize city;

- (void)dealloc {
    if (pk) {
        [pk release];
        pk = nil;
    }
    
    if (addBlockPK) {
        [addBlockPK release];
        addBlockPK = nil;
    }
    
    if (showType) {
        [showType release];
        showType = nil;
    }
    
    if (blockTitle) {
        [blockTitle release];
        blockTitle = nil;
    }
    
    if (apiURL) {
        [apiURL release];
        apiURL = nil;
    }
    
    if (pic) {
        [pic release];
        pic = nil;
    }
    
    if (type) {
        [type release];
        type = nil;
    }
    self.permissions = nil;
    
    if (tabinfoUrl) {
        [tabinfoUrl release];
        tabinfoUrl = nil;
    }
    
    if (userId) {
        [userId release];
        userId = nil;
    }
    
    if (screen_name) {
        [screen_name release];
        screen_name = nil;
    }
    
    if (profile_image_url) {
        [profile_image_url release];
        profile_image_url = nil;
    }
    
    if (code) {
        [code release];
        code = nil;
    }
    
    if (accessToken) {
        [accessToken release];
        accessToken = nil;
    }
    self.accessTokenSecret = nil;
    self.loginName = nil;
    self.loginPsd = nil;
    self.openPsd = nil;
    
    self.opendId = nil;
    self.country = nil;
    self.province = nil;
    self.city = nil;
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {

    }
    
    return self;
}

- (void)fillWithDictionary:(NSDictionary*)dictionary {
    [super fillWithDictionary:dictionary];
    
	if ([self checkDictionary:dictionary containKey:@"pk"]) {
		self.pk = [self getNSStringFromDictionary:dictionary forKey:@"pk"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"addBlockPK"]) {
		self.addBlockPK = [self getNSStringFromDictionary:dictionary forKey:@"addBlockPK"];
	}
	
	if ([self checkDictionary:dictionary containKey:@"showType"]) {
		self.showType = [self getNSStringFromDictionary:dictionary forKey:@"showType"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"block_title"]) {
		self.blockTitle = [self getNSStringFromDictionary:dictionary forKey:@"block_title"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"api_url"]) {
		self.apiURL = [self getNSStringFromDictionary:dictionary forKey:@"api_url"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"pic"]) {
		self.pic = [self getNSStringFromDictionary:dictionary forKey:@"pic"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"type"]) {
		self.type = [self getNSStringFromDictionary:dictionary forKey:@"type"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"permissions"]) {
		self.permissions = [self getNSStringFromDictionary:dictionary forKey:@"permissions"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"tabinfoUrl"]) {
		self.tabinfoUrl = [self getNSStringFromDictionary:dictionary forKey:@"tabinfoUrl"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"userId"]) {
		self.userId = [self getNSStringFromDictionary:dictionary forKey:@"userId"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"screen_name"]) {
		self.screen_name = [self getNSStringFromDictionary:dictionary forKey:@"screen_name"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"profile_image_url"]) {
		self.profile_image_url = [self getNSStringFromDictionary:dictionary forKey:@"profile_image_url"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"code"]) {
		self.code = [self getNSStringFromDictionary:dictionary forKey:@"code"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"accessToken"]) {
		self.accessToken = [self getNSStringFromDictionary:dictionary forKey:@"accessToken"];
	}

    if ([self checkDictionary:dictionary containKey:@"accessTokenSecret"]) {
		self.accessTokenSecret = [self getNSStringFromDictionary:dictionary forKey:@"accessTokenSecret"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"remindIn"]) {
		self.remindIn = [self getIntFromDictionary:dictionary forKey:@"remindIn"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"loginInTime"]) {
		self.loginInTime = [self getIntFromDictionary:dictionary forKey:@"loginInTime"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"loginName"]) {
		self.loginName = [self getNSStringFromDictionary:dictionary forKey:@"loginName"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"loginPsd"]) {
		self.loginPsd = [self getNSStringFromDictionary:dictionary forKey:@"loginPsd"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"openPsd"]) {
		self.openPsd = [self getNSStringFromDictionary:dictionary forKey:@"openPsd"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"opendId"]) {
		self.opendId = [self getNSStringFromDictionary:dictionary forKey:@"opendId"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"country"]) {
		self.country = [self getNSStringFromDictionary:dictionary forKey:@"country"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"province"]) {
		self.province = [self getNSStringFromDictionary:dictionary forKey:@"province"];
	}
    
    if ([self checkDictionary:dictionary containKey:@"city"]) {
		self.city = [self getNSStringFromDictionary:dictionary forKey:@"city"];
	}
}

- (NSMutableDictionary*)toDictionary {
	NSMutableDictionary* dict = [super toDictionary];
    
    [self fillDictionary:dict withNSString:self.pk forKey:@"pk"];
    [self fillDictionary:dict withNSString:self.addBlockPK forKey:@"addBlockPK"];
    [self fillDictionary:dict withNSString:self.showType forKey:@"showType"];
    [self fillDictionary:dict withNSString:self.blockTitle forKey:@"block_title"];
    [self fillDictionary:dict withNSString:self.apiURL forKey:@"api_url"];
    [self fillDictionary:dict withNSString:self.pic forKey:@"pic"];
    [self fillDictionary:dict withNSString:self.type forKey:@"type"];
    [self fillDictionary:dict withNSString:self.permissions forKey:@"permissions"];
    [self fillDictionary:dict withNSString:self.tabinfoUrl forKey:@"tabinfoUrl"];
    [self fillDictionary:dict withNSString:self.userId forKey:@"userId"];
    [self fillDictionary:dict withNSString:self.screen_name forKey:@"screen_name"];
    [self fillDictionary:dict withNSString:self.profile_image_url forKey:@"profile_image_url"];
    [self fillDictionary:dict withNSString:self.code forKey:@"code"];
    [self fillDictionary:dict withNSString:self.accessToken forKey:@"accessToken"];
    [self fillDictionary:dict withNSString:self.accessTokenSecret forKey:@"accessTokenSecret"];
    [self fillDictionary:dict withInt:self.remindIn forKey:@"remindIn"];
    [self fillDictionary:dict withInt:self.loginInTime forKey:@"loginInTime"];
    [self fillDictionary:dict withNSString:self.loginName forKey:@"loginName"];
    [self fillDictionary:dict withNSString:self.loginPsd forKey:@"loginPsd"];
    [self fillDictionary:dict withNSString:self.openPsd forKey:@"openPsd"];
    
    [self fillDictionary:dict withNSString:self.opendId forKey:@"opendId"];
    [self fillDictionary:dict withNSString:self.country forKey:@"country"];
    [self fillDictionary:dict withNSString:self.province forKey:@"province"];
    [self fillDictionary:dict withNSString:self.city forKey:@"city"];
    
	return dict;
}

- (BOOL)checkWbAccessTokenIsInvalid {
    if (![self.type isEqualToString:@"weibo"] && ![self.type isEqualToString:@"qq"]) {
        return NO;
    }
    int nowTime = [[NSDate date] timeIntervalSince1970];
    int remindTime = nowTime-self.loginInTime;
    return remindTime>=self.remindIn;
}

@end
