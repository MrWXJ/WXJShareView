//
//  ShareTableViewCell.h
//  WXJShareView
//
//  Created by MrWXJ on 2018/8/4.
//  Copyright © 2018年 MrWXJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WColl.h"

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

@interface ShareTableViewCell : UITableViewCell

@property (nonatomic,strong) WColl *collectionView;
@property (nonatomic,strong) UIImageView *itemImageView;
@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,assign) NSInteger collectionTag;// 做标记

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

- (void)setCollectionViewTag:(NSInteger)tag;

@end
