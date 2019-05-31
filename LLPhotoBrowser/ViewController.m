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
    NSArray *_images; //支持UIImage对象、网络图片地址、本地文件路径
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _images = @[[UIImage imageNamed:@"1"],
                @"http://www.vasueyun.cn/gif/flag.gif",
                [[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpeg"],
                [UIImage imageNamed:@"WX_pay"],
                @"http://www.vasueyun.cn/image/bg.png",
                @"http://www.vasueyun.cn/gif/fire.gif",
                @"http://www.vasueyun.cn/gif/snow.gif",
                @"http://www.vasueyun.cn/gif/thanks.gif"];
}

- (IBAction)btnClick:(UIButton *)sender {
    LLPhotoBrowser *photoBrowser = [[LLPhotoBrowser alloc] initWithImages:_images currentIndex:0];
    photoBrowser.delegate = self;
    [self presentViewController:photoBrowser animated:YES completion:nil];
}

- (void)photoBrowser:(LLPhotoBrowser *)photoBrowser didSelectImage:(UIImage *)image {
    NSLog(@"选中的图片为:%@",image);
}

@end
