//
//  LLCollectionViewCell.m
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLCollectionViewCell.h"

@implementation LLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _photo = [[LLPhoto alloc] initWithFrame:CGRectMake(0, 0, PHOTO_WIDTH, PHOTO_HEIGHT)];
        [self addSubview:_photo];
    }
    return self;
}

@end
