//
//  LLPhotoBrowser.h
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LLPhotoBrowserDelegate;

@interface LLPhotoBrowser : UIViewController

@property (nonatomic, weak) id<LLPhotoBrowserDelegate> delegate;

- (instancetype)initWithImages:(NSArray<UIImage *> *)images currentIndex:(NSInteger)currentIndex;

@end

@protocol LLPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBrowser:(LLPhotoBrowser *)photoBrowser didSelectImage:(id)image;

@end
