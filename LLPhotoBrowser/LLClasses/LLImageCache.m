//
//  LLImageCache.m
//  LLFileManager
//
//  Created by zhaomengWang on 17/3/14.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLImageCache.h"
#import "LLFileManager.h"

@implementation NSData (Base64)

- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth
{
    //ensure wrapWidth is a multiple of 4
    wrapWidth = (wrapWidth / 4) * 4;
    
    const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long inputLength = [self length];
    const unsigned char *inputBytes = [self bytes];
    
    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    maxOutputLength += wrapWidth? (maxOutputLength / wrapWidth) * 2: 0;
    unsigned char *outputBytes = (unsigned char *)malloc((int)maxOutputLength);
    
    long long i;
    long long outputLength = 0;
    for (i = 0; i < inputLength - 2; i += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[i + 1] & 0x0F) << 2) | ((inputBytes[i + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[i + 2] & 0x3F];
        
        //add line break
        if (wrapWidth && (outputLength + 2) % (wrapWidth + 2) == 0)
        {
            outputBytes[outputLength++] = '\r';
            outputBytes[outputLength++] = '\n';
        }
    }
    
    //handle left-over data
    if (i == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[i] & 0x03) << 4) | ((inputBytes[i + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[i + 1] & 0x0F) << 2];
        outputBytes[outputLength++] =   '=';
    }
    else if (i == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[i] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, (int)outputLength);
        return [[NSString alloc] initWithBytesNoCopy:outputBytes
                                              length:(int)outputLength
                                            encoding:NSASCIIStringEncoding
                                        freeWhenDone:YES];
    }
    else if (outputBytes)
    {
        free(outputBytes);
    }
    return nil;
}

- (NSString *)base64EncodedString
{
    return [self base64EncodedStringWithWrapWidth:0];
}

@end


@implementation NSString (Base64)

- (NSString *)base64EncodedString
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data base64EncodedString];
}

@end

#define APP_CachePath     \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@implementation LLImageCache{
    NSString            *_cachePath;
    NSMutableDictionary *_memoryCache;
}

+ (instancetype)imageCache {
    static LLImageCache *imageCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[LLImageCache alloc] initWithCachePath:[APP_CachePath stringByAppendingPathComponent:@"LLImageCache"]];
    });
    return imageCache;
}

- (instancetype)initWithCachePath:(NSString *)cachePath {
    self = [super init];
    if (self) {
        _cachePath = cachePath;
        _memoryCache = [[NSMutableDictionary alloc] initWithCapacity:0];
        [LLFileManager createDirectoryAtPath:cachePath];
    }
    return self;
}

- (NSData *)getDataWithUrl:(NSURL *)url {
    
    //1、从缓存获取
    NSString *urlKey = [url.absoluteString base64EncodedString];
    NSData *data = [_memoryCache objectForKey:urlKey];
    if (data) {
        return data;
    }
    
    //2、从本地获取
    NSString *cachePath = [_cachePath stringByAppendingPathComponent:urlKey];
    if ([LLFileManager fileExistsAtPath:cachePath]) {
        data = [NSData dataWithContentsOfFile:cachePath];
        if (data) {
            //存到缓存
            [_memoryCache setObject:data forKey:urlKey];
            return data;
        }
    }
    
    //3、从网络获取
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if (urlData) {
        //存到缓存
        [_memoryCache setObject:urlData forKey:urlKey];
        //存到本地
        [LLFileManager writeFile:urlData toPath:cachePath];
        
        return urlData;
    }
    else {
        NSLog(@"图片下载失败");
        return nil;
    }
}

- (void)clearMemory {
    [_memoryCache removeAllObjects];
}

- (void)clearImageCacheCompletion:(void(^)())completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self clearMemory];
        if ([LLFileManager deleteFileAtPath:_cachePath error:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_cachePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    });
}

@end
