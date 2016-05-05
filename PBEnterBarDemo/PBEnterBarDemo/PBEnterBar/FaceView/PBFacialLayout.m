//
//  PBFacialLayout.m
//  SayPal
//
//  Created by Jpache on 16/2/19.
//  Copyright © 2016年 cusflo. All rights reserved.
//

#import "PBFacialLayout.h"

#define ONEWIDTH ([UIScreen mainScreen].bounds.size.width / 375)
#define ONEHEIGHT ([UIScreen mainScreen].bounds.size.height / 667)

@interface PBFacialLayout ()

/**
 *  存视图的布局方式
 */
@property (nonatomic, strong) NSMutableArray *m_allItemAttributeArray;
/**
 *  存每列的最新高度(每次加入itme时会在该字典中寻找最短列, 根据最短列的高度, 生成新试图, 然后更新字典中的数据)
 */
@property (nonatomic, strong) NSMutableDictionary *m_everyColumsHeightDic;

@end

@implementation PBFacialLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _m_numberOfColums = 7;
        _m_numberOfLines = 3;
        _m_lineSpacing = 0;
        _m_allItemAttributeArray = [NSMutableArray array];
        _m_everyColumsHeightDic = [NSMutableDictionary dictionary];
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // 根据有多少行和视图的间隔, 计算出行高列宽
    CGFloat itemWidth = (self.collectionView.bounds.size.width - (_m_lineSpacing * _m_numberOfColums)) / _m_numberOfColums;
    [_m_allItemAttributeArray removeAllObjects];
    
    // 初始化每行的原始 item 数量
    for (int i = 0; i < _m_numberOfLines; i++) {
        [self.m_everyColumsHeightDic setObject:@(0) forKey:[@(i) description]];
    }
    
    // 设置每个分区的总视图数量, 这里用一个分区
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        // 得到当前 item 应所在的行的 index
        NSInteger canUseLine = [self getCanUseLine];
        
        // 得到当前 item 所在行的 item 个数
        NSInteger currentLineItemCount = [_m_everyColumsHeightDic[[@(canUseLine) description]] integerValue];
        
        // 计算 item 的x
        CGFloat x = _m_lineSpacing * (currentLineItemCount / _m_numberOfColums) + (_m_lineSpacing + itemWidth) * currentLineItemCount;
        
        // 计算 item 的y
        CGFloat y = _m_lineSpacing + (_m_lineSpacing + self.collectionView.frame.size.height / _m_numberOfLines) * canUseLine;
        
        // 计算 item 高度
        CGFloat itemHeight = self.collectionView.frame.size.height / _m_numberOfLines;
        
        // 生成布局信息
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = CGRectMake(x, y, itemWidth, itemHeight);
        
        [_m_allItemAttributeArray addObject:attribute];
        
        currentLineItemCount += 1;
        
        // 更新字典中布局信息
        [_m_everyColumsHeightDic setObject:@(currentLineItemCount) forKey:[@(canUseLine) description]];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_m_allItemAttributeArray.count];
    [_m_allItemAttributeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *attributes = obj;
        //将指定区域内的布局信息放入数组
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [array addObject:attributes];
        }
    }];
    return array;
}

- (CGSize)collectionViewContentSize {
    
    NSString *str = [@(0) description];
    
    CGFloat itemWidth = (self.collectionView.bounds.size.width - (_m_lineSpacing * _m_numberOfColums)) / _m_numberOfColums;
    
    return CGSizeMake(_m_lineSpacing + (_m_lineSpacing + itemWidth) * [_m_everyColumsHeightDic[str] floatValue], 0.0);
}
int haha = 0;
// 获得当前 item 应该所在行的 index
- (NSInteger)getCanUseLine {

    NSInteger count = [_m_everyColumsHeightDic count];
    NSInteger lineIndex = 0;
    for (int i = 0; i < count; i++) {
        
        if ([_m_everyColumsHeightDic[[@(i) description]] integerValue] % _m_numberOfColums == 0 && [_m_everyColumsHeightDic[[@(i) description]] integerValue] != 0 && i != 2 && [_m_everyColumsHeightDic[[@(i) description]] integerValue] == [_m_everyColumsHeightDic[[@(0) description]] integerValue]) {
            
            lineIndex = i + 1;
        }else if (i == 0 && [_m_everyColumsHeightDic[[@(i) description]] integerValue] == 0) {
            
            lineIndex = i;
        }else if (i == _m_numberOfLines - 1 && [_m_everyColumsHeightDic[[@(i) description]] integerValue] % _m_numberOfColums == 0 && [_m_everyColumsHeightDic[[@(i) description]] integerValue] != 0 && [_m_everyColumsHeightDic[[@(i) description]] integerValue] == [_m_everyColumsHeightDic[[@(0) description]] integerValue]) {
            
            lineIndex = 0;
        }
    }
    return lineIndex;
}

@end
