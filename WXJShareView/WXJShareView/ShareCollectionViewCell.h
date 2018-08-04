//
//  ShareCollectionViewCell.h
//  WXJShareView
//
//  Created by MrWXJ on 2018/8/4.
//  Copyright © 2018年 MrWXJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCollectionViewCell : UICollectionViewCell

/**
 创建cell
 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
/**
 传入数据
 */
- (void)setName:(NSString *)name imageName:(NSString *)imageName;


@end
