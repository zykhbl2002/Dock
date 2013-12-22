//
//  MyUnit.m
//  WBHui
//
//  Created by kenny on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyUnit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation MyUnit

//NSSTring
+ (BOOL)NSStringIsEmpty:(NSString*)str {
	return  (str == nil || [@"" isEqual:str]);
}

+ (NSString*)myMD5:(NSString*)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString*)md5:(id)strT {
	NSString *str = @"";
    
	NSString *classN = [[strT class] description];	
	if (![@"NSString" isEqual: classN] && ![@"NSCFString" isEqual: classN] && ![@"__NSCFString" isEqual: classN]) {		
		if ([@"NSNumber" isEqual:classN]) {
			NSNumber *str_number = (NSNumber*)strT;
			str = [str_number stringValue];
		}		
	} else {
		str = (NSString*)strT;
	}	
	
	return [[self class] myMD5:str];
}

+ (NSString*)formatDate:(NSDate*)date withFormat:(NSString*)format {
	NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
	[dateFormater setDateFormat:format];
	NSString *reString = [dateFormater stringFromDate:date];
	[dateFormater release];
	return reString;
}

+ (NSString*)makeDownloadDataPlistFilepathByBlockPk:(NSString*)pk blockType:(NSString*)blockType {
	NSString *url_md5 = [[self class] md5:[NSString stringWithFormat:@"%@_%@", pk, blockType]];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"download_res/data/%@.plist", url_md5]];
}

+ (NSString*)makeDownloadingDataPlistFilepath {
	NSString *url_md5 = [[self class] md5:@"downloading"];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"download_res/data/%@.plist", url_md5]];
}

+ (NSString*)makeDownloadFilepath:(NSString*)filename type:(NSString*)type {
	NSString *url_md5 = [[self class] md5:filename];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"download_res/data/%@.%@", url_md5, type]];
}

+ (NSString*)makeTmpDownloadFilepath:(NSString*)filename type:(NSString*)type {
	NSString *url_md5 = [[self class] md5:filename];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"download_res/tmp/%@.%@", url_md5, type]];
}

+ (NSString*)makeWeiboDataPlistFilepathByBlockPk:(NSString*)pk blockType:(NSString*)blockType {
	NSString *url_md5 = [[self class] md5:[NSString stringWithFormat:@"%@_%@", pk, blockType]];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"weibo_res/data/%@.plist", url_md5]];
}

+ (NSString*)makeWeiboSubDataPlistFilepathByBlockPk:(NSString*)pk blockType:(NSString*)blockType {
	NSString *url_md5 = [[self class] md5:[NSString stringWithFormat:@"%@_%@", pk, blockType]];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"weibo_res/data/sub/%@.plist", url_md5]];
}

+ (NSString*)makeImageFilepathByUrl:(NSString*)url {
	NSString *url_md5 = [[self class] md5:url];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"weibo_res/images/%@.data", url_md5]];
}

+ (NSString*)makeSubImageFilepathByUrl:(NSString*)url {
	NSString *url_md5 = [[self class] md5:url];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"weibo_res/images/sub/%@.data", url_md5]];
}

+ (NSString*)makeImageFilepathByUrlForGif:(NSString*)url {
	NSString *url_md5 = [[self class] md5:url];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"weibo_res/images/%@.gif", url_md5]];
}

+ (NSString*)makeSubImageFilepathByUrlForGif:(NSString*)url {
	NSString *url_md5 = [[self class] md5:url];
	return [[self class] makeUserFilePath:[NSString stringWithFormat:@"weibo_res/images/sub/%@.gif", url_md5]];
}

//NSFileMangage
+ (NSString*)makeDocumentFilePath:(NSString*)filename {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    return filePath;
}

+ (NSString*)makeUserFilePath:(NSString*)filename {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:filename];
    return filePath;
}

+ (NSString*)makeTmpFilePath:(NSString*)filename {	
	NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
	return filePath;
}

+ (NSString*)makeAppFilePath:(NSString*)filename {
	NSString *appDirectory = [[NSBundle mainBundle] resourcePath];
	NSString *filePath = [appDirectory stringByAppendingPathComponent:filename];
	
	return filePath;
}

+ (void)makeDir:(NSString*)dir {
	NSFileManager *fm = [NSFileManager defaultManager];
	
	if ([fm fileExistsAtPath:dir]) {
		return ;
	} else {
		NSError* error;
		[fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
	}
}

+ (void)makeDirWithFilePath:(NSString*)filepath {
	if (!filepath) {
		return ;
	}
	NSString *filename = [filepath lastPathComponent];
	NSString *dirpath = [filepath substringToIndex:([filepath length]-[filename length])];
	
	return [[self class] makeDir:dirpath];	
}

+ (BOOL)checkFilepathExists:(NSString*)filepath {
	NSFileManager *fm = [NSFileManager defaultManager];
	return [fm fileExistsAtPath:filepath];
}

+ (BOOL)removeFile:(NSString*)filepath {
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL isDir;
	if ([fm isDeletableFileAtPath:filepath]  && [fm fileExistsAtPath:filepath isDirectory:&isDir] && !isDir) {
		return [fm removeItemAtPath:filepath error:NULL];
	}
	return TRUE;
}

+ (BOOL)checkDirExists:(NSString*)dir {
	NSFileManager *fm = [NSFileManager defaultManager];
	BOOL isDir;
	return ([fm fileExistsAtPath:dir isDirectory:&isDir] && isDir);
	
}

+ (BOOL)removeFilesInDir:(NSString*)dir removeRootDir:(BOOL)rRootDir {
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([[self class] checkDirExists:dir]) {
		NSArray *fileArr = [fm contentsOfDirectoryAtPath:dir error:NULL];
		if (fileArr != nil && [fileArr count] > 0) {
			for (NSString *filename in fileArr) {
				NSString *filepath = [dir stringByAppendingPathComponent:filename];
				[[self class] removeFile:filepath];
			}
		}
		
		if (rRootDir) {
			[fm removeItemAtPath:dir error:NULL];
		}
	} else {

	}
	
	return YES;
}

+ (BOOL)removeFilesInDir:(NSString*)dir {
	return [[self class] removeFilesInDir:dir removeRootDir:NO];
}

+ (void)cleanImages {
    NSString *imagesDir= [[self class] makeUserFilePath:@"weibo_res/images/sub"];
	
	[[self class] removeFilesInDir:imagesDir];
}

+ (void)cleanTexts {
    NSString *textsDir= [[self class] makeUserFilePath:@"weibo_res/data/sub"];
	
	[[self class] removeFilesInDir:textsDir];
}

//CGRect
+ (CGRect)CGRectFixInt:(CGRect)rect {
	return CGRectMake((int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height);
}

+ (NSString*)getSubSettingFileName:(BlockModel*)blockModel {
    return [NSString stringWithFormat:@"%@%@Setting", blockModel.pk, blockModel.type];
}

@end
