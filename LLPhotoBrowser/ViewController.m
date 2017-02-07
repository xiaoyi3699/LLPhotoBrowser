//
//  ViewController.m
//  LLPhotoBrowser
//
//  Created by zhaomengWang on 17/2/6.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "LLPhotoBrowser.h"
@interface ViewController ()<LLPhotoBrowserDelegate>{
    NSArray *_images;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _images = @[[UIImage imageNamed:@"1"],
                [UIImage imageNamed:@"2.jpeg"],
                [UIImage imageNamed:@"WX_pay"],
                [UIImage imageNamed:@"1"],
                [UIImage imageNamed:@"2.jpeg"],
                [UIImage imageNamed:@"WX_pay"]];
}

- (IBAction)btnClick:(UIButton *)sender {
    LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithImages:_images currentIndex:1];
    photoBrowser.delegate = self;
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

- (void)photoBrowser:(LLPhotoBrowser *)photoBrowser didSelectImage:(UIImage *)image {
    NSLog(@"选中的图片为:%@",image);
}

@end
