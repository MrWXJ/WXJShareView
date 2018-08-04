//
//  WXJShareView.h
//  WXJShareView
//
//  Created by MrWXJ on 2018/8/4.
//  Copyright © 2018年 MrWXJ. All rights reserved.
//
//-------------
//UITableView和UICollectionView结合的分享控件
//-------------

#import <UIKit/UIKit.h>
#import "ShareTableViewCell.h"
#import "ShareCollectionViewCell.h"
#import <WebKit/WebKit.h>
#import "UIView+WXJExtension.h"
#import "WColl.h"

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface WXJShareView : UIView
// 方便设置
@property (nonatomic,strong) UITableView *tableView;

/**
 双层操作的分享控件(带刷新页面和浏览器打开等)
 
 @param title 分享标题
 @param shareContent 分享内容
 @param shareImage 图片
 @param shareUrl 链接
 @param reloadPage 刷新页面
 @param web WKWebView
 @return WXJShareView
 */
- (instancetype)initWXJShareWithTitle:(NSString *)title
                         shareContent:(NSString *)shareContent
                           shareImage:(NSString *)shareImage
                             shareUrl:(NSString *)shareUrl
                           reloadPage:(BOOL)reloadPage
                          reloadOfWeb:(WKWebView *)web;

/**
 显示View
 */
- (void)show;


/**
 * 使用说明
 * 导入#import "WXJShareView.h"
 * 使用下方法 配置相关信息即可
 * [[[WXJShareView alloc] initWXJShareWithTitle:@"标题" shareContent:@"内容" shareImage:@"" shareUrl:@"http://www.baidu.com" reloadPage:YES reloadOfWeb:nil] show];
 */


@end
