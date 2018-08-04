//
//  WXJShareView.m
//  WXJShareView
//
//  Created by MrWXJ on 2018/8/4.
//  Copyright © 2018年 MrWXJ. All rights reserved.
//

#import "WXJShareView.h"

@interface WXJShareView ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *array2;
@property (nonatomic, strong) NSArray *array1;
@property (nonatomic, strong) NSArray *imgArray1;
@property (nonatomic, strong) NSMutableArray *imgArray2;

@property (nonatomic, assign) BOOL reload;
@property (nonatomic, strong) NSString *shareImage;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareContent;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WXJShareView

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
                          reloadOfWeb:(WKWebView *)web {
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    if (self) {
        self.shareTitle = title;
        self.shareContent = shareContent;
        self.shareImage = shareImage;
        self.shareUrl = shareUrl;
        self.reload = reloadPage;
        self.webView = web;
        
        [self careatTableView];
    }
    return self;
}

/**
 创建TableView
 */
- (void)careatTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HEIGHT - 272, WIDTH, 272) style:UITableViewStylePlain];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
}

#pragma mark ========= 界面区-UITableView =========

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1f;
    } else {
        return 1.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBCOLOR(240, 240, 240, 1);
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 20, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.1;
        [view addSubview:line];
        return view;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 50.0f;
    } else {
        return 0.1f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footerView = [[UIView alloc] init];
        footerView.width = WIDTH;
        footerView.height = 50;
        footerView.backgroundColor = RGBCOLOR(244, 244, 244, 1);
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        [_cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RGBCOLOR(54, 54, 54, 1) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setBackgroundColor:RGBCOLOR(250, 250, 250, 1)];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
        longPress.minimumPressDuration = 0.2;
        [_cancelButton addGestureRecognizer:longPress];
        [footerView addSubview:_cancelButton];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.1;
        [_cancelButton addSubview:line];
        
        return footerView;
    } else {
        return nil;
    }
}
-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        _cancelButton.backgroundColor = RGBCOLOR(240, 240, 240, 1);
    } else {
        _cancelButton.backgroundColor = RGBCOLOR(250, 250, 250, 1);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    ShareTableViewCell *cell = (ShareTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = RGBCOLOR(244, 244, 244, 1);
    if (!cell) {
        cell = [[ShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setCollectionViewTag:indexPath.section];//给每个分区的collectionView添加标记
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ShareTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    NSInteger index = cell.collectionView.indexPath.row;
    CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    [cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
}

#pragma mark ------ 数据 ------

- (NSMutableArray *)array2 {
    if (!_array2) {
        _array2 = [NSMutableArray arrayWithObjects:@"微信收藏",@"Safari打开",@"复制链接",@"刷新",nil];
        if (_reload == NO) {
            [_array2 removeObject:@"刷新"];
        }
    }
    return _array2;
}

- (NSArray *)array1 {
    if (!_array1) {
        _array1 = @[@"微信",@"朋友圈",@"QQ",@"空间",@"邮件",@"短信"];
    }
    return _array1;
}

- (NSArray *)imgArray1 {
    if (!_imgArray1) {
        _imgArray1 = @[@"wechat",@"py",@"sns_icon_24",@"sns_icon_6",@"sns_icon_18",@"messa"];
    }
    return _imgArray1;
}

- (NSMutableArray *)imgArray2 {
    if (!_imgArray2) {
        _imgArray2 = [NSMutableArray arrayWithObjects:@"col",@"safari",@"copy",@"reload", nil];
        if (_reload == NO) {
            [_imgArray2 removeObject:@"reload"];
        }
    }
    return _imgArray2;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 0) {
        return self.array1.count;
    } else {
        return self.array2.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, 85);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

//定义每个UICollectionView 纵向的间距,最小列间距
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 3;
//}
//
////cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareCollectionViewCell *cell = [ShareCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    if (collectionView.tag == 0) {
        [cell setName:_array1[indexPath.row] imageName:self.imgArray1[indexPath.row]];
    } else {
        [cell setName:_array2[indexPath.row] imageName:self.imgArray2[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 延迟0.1秒隐藏让用户既看到点击效果又不影响体验
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelBtn:nil];
    });
    
//    [ShareViewTools shareInstance].shareUrl = _shareUrl;
//    [ShareViewTools shareInstance].imageString = _imageString;
//    [ShareViewTools shareInstance].shareTitle = _shareTitle;
    
//    int shareType = 0;
//    if (collectionView.tag == 0) {
//        switch (indexPath.row) {
//            case 0:
//                shareType = SSDKPlatformSubTypeWechatSession;
//                break;
//            case 1:
//                shareType = SSDKPlatformSubTypeWechatTimeline;
//                break;
//            case 2:
//                shareType = SSDKPlatformSubTypeQQFriend;
//                break;
//            case 3:
//                shareType = SSDKPlatformSubTypeQZone;
//                break;
//            case 4:
//                shareType = SSDKPlatformTypeMail;
//                break;
//            case 5:
//                shareType = SSDKPlatformTypeSMS;
//                break;
//
//            default:
//                break;
//        }
//    } else {
//        switch (indexPath.row) {
//            case 0:
//                shareType = SSDKPlatformSubTypeWechatFav;
//                break;
//            case 1:
//                break;
//            case 2:
//                shareType = SSDKPlatformTypeCopy;
//                break;
//            case 3:
//                break;
//
//            default:
//                break;
//        }
//    }
    
    if ((collectionView.tag == 1) && (indexPath.row == 1 || indexPath.row == 3)) {
        if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_shareUrl] options:@{} completionHandler:nil];
        } else {
            // 清除页面缓存
            [self clearTheCacheForWebView];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_shareUrl]];
            request.timeoutInterval = 10.0f;
            [self.webView loadRequest:request];
        }
    } else {
//        [[ShareViewTools shareInstance] shareWithType:shareType];
    }
}

#pragma mark ------ 清除h5页面的缓存 ------

- (void)clearTheCacheForWebView {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f) {
        // 清除网页H5缓存 iOS 9 以上
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            NSLog(@"网页清除缓存完成");
        }];
    } else {
        // iOS 7,8
        NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                   NSUserDomainMask, YES)[0];
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
        NSString *webKitFolderInCachesfs = [NSString
                                            stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
        NSError *error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        
        /* iOS7.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
    }
}


/**
 显示View
 */
- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    window.backgroundColor = [UIColor redColor];
    
    self.tableView.y = HEIGHT;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.y = HEIGHT - 272;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    } completion:^(BOOL finished) {
        
    }];
}

/**
 这里为了防止点击_tableView也响应父view的事件

 @param gestureRecognizer gestureRecognizer
 @param touch touch
 @return BOOL
 */
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    if ([touch.view isDescendantOfView:_tableView]) {
//        return NO;
//    }
//    return YES;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self cancelBtn:nil];
}

// 移除视图
- (void)cancelBtn:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.y = HEIGHT;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.tableView removeFromSuperview];
    }];
}

@end
