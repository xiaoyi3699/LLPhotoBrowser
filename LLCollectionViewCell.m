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
        
        CGRect rect = self.bounds;
        rect.size.width -= 10;
        rect.origin.x = 5;
        _photo = [[LLPhoto alloc] initWithFrame:rect];
        _photo.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_photo];
    }
    return self;
}

- (void)layoutSubviews {
    _photo.zoomScale = 1.0;
    _photo.contentSize = _photo.bounds.size;
}

@end
