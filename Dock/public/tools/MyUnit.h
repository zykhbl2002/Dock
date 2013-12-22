//
//  MyUnit.h
//  WBHui
//
//  Created by kenny on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockModel.h"

@interface MyUnit : NSObject

//NSSTring
+ (BOOL)NSStringIsEmpty:(NSString*)str;
+ (NSString*)myMD5:(NSString*)str;
+ (NSString*)md5:(id)strT;
+ (NSString*)formatDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSString*)makeDownloadDataPlistFilepathByBlockPk:(NSString*)pk blockType:(NSString*)blockType;
+ (NSString*)makeDownloadingDataPlistFilepath;
+ (NSString*)makeDownloadFilepath:(NSString*)filename type:(NSString*)type;
+ (NSString*)makeTmpDownloadFilepath:(NSString*)filename type:(NSString*)type;
+ (NSString*)makeWeiboDataPlistFilepathByBlockPk:(NSString*)pk blockType:(NSString*)blockType;
+ (NSString*)makeWeiboSubDataPlistFilepathByBlockPk:(NSString*)pk blockType:(NSString*)blockType;
+ (NSString*)makeImageFilepathByUrl:(NSString*)url;
+ (NSString*)makeSubImageFilepathByUrl:(NSString*)url;
+ (NSString*)makeImageFilepathByUrlForGif:(NSString*)url;
+ (NSString*)makeSubImageFilepathByUrlForGif:(NSString*)url;

//NSFileMangage
+ (NSString*)makeDocumentFilePath:(NSString*)filename;
+ (NSString*)makeUserFilePath:(NSString*)filename;
+ (NSString*)makeTmpFilePath:(NSString*)filename;
+ (NSString*)makeAppFilePath:(NSString*)filename;

+ (void)makeDir:(NSString*)dir;
+ (void)makeDirWithFilePath:(NSString*)filepath;
+ (BOOL)checkFilepathExists:(NSString*)filepath;
+ (BOOL)removeFile:(NSString*)filepath;
+ (BOOL)checkDirExists:(NSString*)dir;
+ (void)cleanImages;
+ (void)cleanTexts;

//CGRect
+ (CGRect)CGRectFixInt:(CGRect)rect;

+ (NSString*)getSubSettingFileName:(BlockModel*)blockModel;

@end
