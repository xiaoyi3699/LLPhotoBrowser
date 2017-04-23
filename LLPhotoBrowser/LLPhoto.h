//
//  LLPhoto.h
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LLPhotoDelegate;
#define MaxSCale 3.0  //最大缩放比例
#define MinScale 1.0  //最小缩放比例

@interface LLPhoto : UIScrollView

///当前显示的图片
@property (nonatomic, strong) id ll_image;

@property (nonatomic, weak)   id<LLPhotoDelegate> ll_delegate;
@end

@protocol LLPhotoDelegate <NSObject>

@optional
- (void)singleClickWithPhoto:(LLPhoto *)photo;

@end
