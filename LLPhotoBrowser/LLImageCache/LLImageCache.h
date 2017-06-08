//
//  LLImageCache.h
//  LLFileManager
//
//  Created by zhaomengWang on 17/3/14.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLImageCache : NSObject

+ (instancetype)imageCache;

/**
 获取网络数据
 */
- (NSData *)getDataWithUrl:(NSURL *)url;

/**
 清理缓存
 */
- (void)clearMemory;

/**
 清理所有数据
 */
- (void)clearImageCacheCompletion:(void(^)())completion;

@end
