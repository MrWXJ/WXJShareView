//
//  ShareTableViewCell.m
//  WXJShareView
//
//  Created by MrWXJ on 2018/8/4.
//  Copyright © 2018年 MrWXJ. All rights reserved.
//

#import "ShareTableViewCell.h"

@implementation ShareTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //    layout.itemSize = CGSizeMake(120, 117);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[WColl alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.frame = CGRectMake(0, 0, WIDTH, 110);
    self.collectionView.backgroundColor = RGBCOLOR(240, 240, 240, 1);
    self.collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.alwaysBounceHorizontal = YES;// 总允许滑动
    [self.contentView addSubview:self.collectionView];
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath {
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    [self.collectionView reloadData];
}

// 增加标识  方便操作
- (void)setCollectionViewTag:(NSInteger)tag {
    self.collectionView.tag = tag;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
