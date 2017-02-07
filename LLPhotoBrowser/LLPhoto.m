//
//  LLPhoto.m
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLPhoto.h"

@interface LLPhoto ()<UIScrollViewDelegate>{
    UIImageView *_imageView;
}
@end

@implementation LLPhoto

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = MinScale;
        self.maximumZoomScale = MaxSCale;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        //_imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
        [self addGestureRecognizer:singleClick];
        
        UITapGestureRecognizer *doubleClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
        doubleClick.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleClick];
        
        [singleClick requireGestureRecognizerToFail:doubleClick];
    }
    return self;
}

#pragma mark - 按图片比例适配imageView的frame
- (void)setCurrentImage:(UIImage *)currentImage {
    CGRect imageFrame;
    if (currentImage.size.width > PHOTO_WIDTH || currentImage.size.height > PHOTO_HEIGHT) {
        CGFloat imageRatio = currentImage.size.width/currentImage.size.height;
        CGFloat photoRatio = PHOTO_WIDTH/PHOTO_HEIGHT;
        
        if (imageRatio > photoRatio) {
            imageFrame.size = CGSizeMake(PHOTO_WIDTH, PHOTO_WIDTH/currentImage.size.width*currentImage.size.height);
            imageFrame.origin.x = 0;
            imageFrame.origin.y = (PHOTO_HEIGHT-imageFrame.size.height)/2.0;
        }
        else {
            imageFrame.size = CGSizeMake(PHOTO_HEIGHT/currentImage.size.height*currentImage.size.width, PHOTO_HEIGHT);
            imageFrame.origin.x = (PHOTO_WIDTH-imageFrame.size.width)/2.0;
            imageFrame.origin.y = 0;
        }
    }
    else {
        imageFrame.size = currentImage.size;
        imageFrame.origin.x = (PHOTO_WIDTH-currentImage.size.width)/2.0;
        imageFrame.origin.y = (PHOTO_HEIGHT-currentImage.size.height)/2.0;
    }
    _imageView.frame = imageFrame;
    _imageView.image = currentImage;
    _currentImage = currentImage;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGFloat photoX = (PHOTO_WIDTH-_imageView.frame.size.width)/2.0;
    CGFloat photoY = (PHOTO_HEIGHT-_imageView.frame.size.height)/2.0;
    CGRect photoF = _imageView.frame;
    
    if (photoX>0) {
        photoF.origin.x = photoX;
    }
    else {
        photoF.origin.x = 0;
    }
    
    if (photoY>0) {
        photoF.origin.y = photoY;
    }
    else {
        photoF.origin.y = 0;
    }
    
    _imageView.frame = photoF;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scale>1) {
        self.isEnlarged = YES;
    }
    else {
        self.isEnlarged = NO;
    }
}

#pragma mark - 手势交互
- (void)singleClick:(UITapGestureRecognizer *)gestureRecognizer {
    if ([self.ll_delegate respondsToSelector:@selector(singleClickWithPhoto:)]) {
        [self.ll_delegate singleClickWithPhoto:self];
    }
}

- (void)doubleClick:(UITapGestureRecognizer *)gestureRecognizer {
    [UIView animateWithDuration:.2 animations:^{
        if (self.isEnlarged) {
            self.zoomScale = MinScale;
        }
        else {
            self.zoomScale = MaxSCale;
        }
    } completion:^(BOOL finished) {
        self.isEnlarged = !self.isEnlarged;
    }];
}

@end
