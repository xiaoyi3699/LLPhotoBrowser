//
//  LLFileManager.h
//  test
//
//  Created by wangzhaomeng on 16/8/23.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLFileManager : NSObject

/**
 文件是否存在
 */
+ (BOOL)fileExistsAtPath:(NSString *)filePath;

/**
 创建文件夹
 */
+ (BOOL)createDirectoryAtPath:(NSString *)path;

/**
 将文件存到沙盒
 */
+ (BOOL)writeFile:(id)file toPath:(NSString *)path;

/**
 删除文件(文件夹)
 */
+ (BOOL)deleteFileAtPath:(NSString *)filePath error:(NSError **)error;

@end
