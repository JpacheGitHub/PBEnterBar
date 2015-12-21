//
//  PBFacialView.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/21.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBFacialView.h"
#import "PBEmojiManager.h"
#import "PBFacialViewCollectionViewCell.h"

#define EMOJIROW 3
#define EMOJICOL 7

@interface PBFacialView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
/**
 *  表情图片数组
 */
@property (nonatomic, strong) NSArray *emojiArray;
/**
 *  表情对应文字数组
 */
@property (nonatomic, strong) NSArray *emojiTitleArray;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation PBFacialView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.emojiArray = [PBEmojiManager allEmoji];
        self.emojiTitleArray = [PBEmojiManager allEmojiTitle];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    NSInteger pageSize = EMOJIROW * EMOJICOL;
    NSInteger totalPage = _emojiArray.count % pageSize == 0 ? _emojiArray.count / pageSize : _emojiArray.count / pageSize + 1;
    
    /***************** collection *****************/
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(self.frame.size.width / EMOJICOL, self.frame.size.height / 4 * 3 / EMOJIROW);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 4 * 3)
                                             collectionViewLayout:flowLayout];
    _collectionView.contentSize = CGSizeMake(self.frame.size.width * totalPage, self.collectionView.frame.size.height);
    _collectionView.backgroundColor = [UIColor colorWithRed:0.9672 green:0.9672 blue:0.9672 alpha:1.0];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"PBFacialViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"facialViewCell"];
    [self addSubview:_collectionView];
    
    /***************** pageControl *****************/
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _collectionView.frame.size.height, self.frame.size.width, self.frame.size.height / 4)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = totalPage;
    [self addSubview:_pageControl];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _emojiArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PBFacialViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"facialViewCell" forIndexPath:indexPath];
    cell.faceImage.image = [UIImage imageNamed:[_emojiArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(selectedFacialView:faceImage:isDelete:)]) {
        [_delegate selectedFacialView:[_emojiTitleArray objectAtIndex:indexPath.row] faceImage:[UIImage imageNamed:[_emojiArray objectAtIndex:indexPath.row]] isDelete:NO];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
