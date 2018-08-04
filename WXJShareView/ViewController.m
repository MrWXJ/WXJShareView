//
//  ViewController.m
//  WXJShareView
//
//  Created by MrWXJ on 2018/8/4.
//  Copyright © 2018年 MrWXJ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)share {
    [[[WXJShareView alloc] initWXJShareWithTitle:@"标题" shareContent:@"内容" shareImage:@"" shareUrl:@"http://www.baidu.com" reloadPage:YES reloadOfWeb:nil] show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
