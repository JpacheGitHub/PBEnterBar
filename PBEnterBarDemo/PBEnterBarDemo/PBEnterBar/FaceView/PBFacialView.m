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
#import "PBFacialLayout.h"

#define EMOJIROW 3
#define EMOJICOL 7

@interface PBFacialView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
/**
 *  表情图片数组
 */
@property (nonatomic, strong) NSMutableArray *emojiArray;
/**
 *  表情对应文字数组
 */
@property (nonatomic, strong) NSMutableArray *emojiTitleArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation PBFacialView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.emojiArray = [[PBEmojiManager allEmoji] mutableCopy];
        self.emojiTitleArray = [[PBEmojiManager allEmojiTitle] mutableCopy];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    _index = 0;
    
    NSInteger pageSize = EMOJIROW * EMOJICOL - 1;
    NSInteger totalPage = _emojiArray.count % pageSize == 0 ? _emojiArray.count / pageSize : _emojiArray.count / pageSize + 1;
    
    /***************** collection *****************/
    PBFacialLayout *layout = [[PBFacialLayout alloc] init];
    layout.m_numberOfLines = 3;
    layout.m_numberOfColums = 7;
    layout.m_lineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height / 4 * 3)
                                             collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor colorWithRed:0.9672 green:0.9672 blue:0.9672 alpha:1.0];
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
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = totalPage;
    [self addSubview:_pageControl];
    
    /***************** sendButton *****************/
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(_collectionView.frame.size.width - 80, self.frame.size.height / 5 * 4, 80, self.frame.size.height / 5);
    _sendButton.backgroundColor = PINK_LIGHT_COLOR;
    [_sendButton setTitle:NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendButton];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger pageSize = EMOJICOL * EMOJIROW;
    NSInteger totalPage = _emojiArray.count % pageSize == 0 ? _emojiArray.count / pageSize : _emojiArray.count / pageSize + 1;
    
    if (_emojiArray.count % 20 != 0) {
        return (_emojiArray.count / 20 + 1) * 20 + totalPage;
    }else {
        return _emojiArray.count + totalPage;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PBFacialViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"facialViewCell" forIndexPath:indexPath];
    cell.faceImage.image = nil;
    if (indexPath.row % 20 == indexPath.row / 20 - 1) {
        cell.faceImage.image = [UIImage imageNamed:@"DeleteEmoticonBtn_ios7"];
    }else {
        
        NSInteger pageSize = EMOJIROW * EMOJICOL - 1;
        NSInteger totalPage = _emojiArray.count % pageSize == 0 ? _emojiArray.count / pageSize : _emojiArray.count / pageSize + 1;
        
        if (indexPath.row >= _emojiArray.count + totalPage - 1) {
            return cell;
        }
        
        _index = indexPath.row - indexPath.row / 20;
        if (_index / 20 != indexPath.row / 20) {
            _index += 1;
        }
        cell.faceImage.image = [UIImage imageNamed:[_emojiArray objectAtIndex:_index]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _index = indexPath.row - indexPath.row / 20;
    if (_index / 20 != indexPath.row / 20) {
        _index += 1;
    }
    
    if ((indexPath.row % 20 == indexPath.row / 20 - 1 && indexPath.row != 0) ||indexPath.row == (EMOJICOL * EMOJIROW - 1)) {
        if (_delegate && [_delegate respondsToSelector:@selector(selectedFacialView:faceImage:isDelete:)]) {
            [_delegate selectedFacialView:@"[删除]"
                                faceImage:[UIImage imageNamed:@"DeleteEmoticonBtn_ios7"]
                                 isDelete:YES];
        }
    }else if (indexPath.row >= _emojiArray.count + _emojiArray.count / 20) {
        return;
    }else {
        if (_delegate && [_delegate respondsToSelector:@selector(selectedFacialView:faceImage:isDelete:)]) {
            [_delegate selectedFacialView:[_emojiTitleArray objectAtIndex:_index]
                                faceImage:[UIImage imageNamed:[_emojiArray objectAtIndex:_index]]
                                 isDelete:NO];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

#pragma mark - action

- (void)sendButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(sendFaceButtonAction:)]) {
        [_delegate sendFaceButtonAction:sender];
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
