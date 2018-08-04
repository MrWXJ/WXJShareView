//
//  ShareCollectionViewCell.m
//  WXJShareView
//
//  Created by MrWXJ on 2018/8/4.
//  Copyright © 2018年 MrWXJ. All rights reserved.
//

#import "ShareCollectionViewCell.h"

//@implementation ShareCollectionViewCell

@interface ShareCollectionViewCell ()

/**
 图标
 */
@property (nonatomic,strong) UIImageView *icon;

/**
 名称
 */
@property (nonatomic,strong) UILabel *nameLabel;

// 背景
@property (nonatomic,strong) UIView *bgView;

@end

@implementation ShareCollectionViewCell

+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"ShareCollectionViewCell";
    [collectionView registerClass:[ShareCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)setName:(NSString *)name imageName:(NSString *)imageName {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _bgView.layer.cornerRadius = 30;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
    }
    
    if (self.icon == nil) {
        self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        [_bgView addSubview:self.icon];
    }
    _icon.image = [UIImage imageNamed:imageName];
    
    if (self.nameLabel == nil) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 60, 20)];
        self.nameLabel.textColor = [UIColor colorWithRed:54/255 green:54/255 blue:54/255 alpha:1];
        self.nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel.textAlignment = 1;
        [self.contentView addSubview:self.nameLabel];
    }
    self.nameLabel.text = name;
}

@end
