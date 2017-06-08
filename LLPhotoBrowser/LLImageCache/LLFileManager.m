//
//  LLFileManager.m
//  test
//
//  Created by wangzhaomeng on 16/8/23.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLFileManager.h"

#define LL_FILE_MANAGER    [NSFileManager defaultManager]

typedef enum{
    LLNotFound          = -400, //路径未找到
    LLIsNotDirectory            //不是文件夹
    
}CustomErrorFailed;
@implementation LLFileManager

+ (BOOL)fileExistsAtPath:(NSString *)filePath{
    if ([LL_FILE_MANAGER fileExistsAtPath:filePath]) {
        return YES;
    }
    NSLog(@"fileExistsAtPath:文件未找到");
    return NO;
}

+ (BOOL)createDirectoryAtPath:(NSString *)path{
    BOOL isDirectory;
    BOOL isExists = [LL_FILE_MANAGER fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExists) {
        if (isDirectory) {
            return YES;
        }
        else{
            NSError *error = nil;
            BOOL result = [LL_FILE_MANAGER createDirectoryAtPath:path
                                     withIntermediateDirectories:YES
                                                      attributes:nil
                                                           error:&error];
            if (error) {
                NSLog(@"创建文件夹失败:%@",error);
            }
            return result;
        }
    }
    else{
        NSError *error = nil;
        BOOL result = [LL_FILE_MANAGER createDirectoryAtPath:path
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&error];
        if (error) {
            NSLog(@"创建文件夹失败:%@",error);
        }
        return result;
    }
}

+ (BOOL)writeFile:(id)file toPath:(NSString *)path{
    BOOL isOK = [file writeToFile:path atomically:YES];
    NSLog(@"文件存储路径为:%@",path);
    return isOK;
}

+ (BOOL)deleteFileAtPath:(NSString *)filePath error:(NSError **)error{
    if ([LL_FILE_MANAGER fileExistsAtPath:filePath]){
        return [LL_FILE_MANAGER removeItemAtPath:filePath error:error];
    }
    NSLog(@"deleteFileAtPath:error:路径未找到");
    return YES;
}

@end
