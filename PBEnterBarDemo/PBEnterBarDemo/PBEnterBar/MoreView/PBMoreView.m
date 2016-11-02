//
//  PBMoreView.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBMoreView.h"
#import "PBMoreViewButton.h"


// button.tag 初始值
static NSInteger const kPBMoreViewBtnTag = 15000;
// 列数
static NSInteger const kPBMoreViewColum = 4;
// 行数
static NSInteger const kPBMoreViewRow = 2;

// button大小
#define kMoreViewButtonWidth (70 * ([UIScreen mainScreen].bounds.size.width / 375))
// button的上下间隔
#define kMoreViewTopPadding (kMoreViewButtonWidth * 0.2)
#define kMoreViewBottomPadding (10 + (kMoreViewButtonWidth * 0.2))

@interface PBMoreView ()<UIScrollViewDelegate>

@property (nonatomic, assign) PBEnterBarType type;
/**
 *  记录当前最大tag值
 */
@property (nonatomic, assign) NSInteger maxIndex;
/**
 *  菜单容器
 */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
/**
 *  图片
 */
@property (nonatomic, strong) PBMoreViewButton *photoButton;
/**
 *  照相
 */
@property (nonatomic, strong) PBMoreViewButton *takePicButton;
/**
 *  打赏
 */
@property (nonatomic, strong) PBMoreViewButton *rewardButton;
/**
 *  定位
 */
@property (nonatomic, strong) PBMoreViewButton *locationButton;
/**
 *  语音通话
 */
@property (nonatomic, strong) PBMoreViewButton *audioCallButton;
/**
 *  视频通话
 */
@property (nonatomic, strong) PBMoreViewButton *videoCallButton;
/**
 *  名片
 */
@property (nonatomic, strong) PBMoreViewButton *cardButton;

@end

@implementation PBMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(PBEnterBarType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _maxIndex = 0;
        _type = type;
        [self createSubViewForTpye:type];
    }
    return self;
}

- (void)createSubViewForTpye:(PBEnterBarType)type {
    self.scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    self.pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = 1;
    [self addSubview:_pageControl];
    
    CGFloat inset = (self.frame.size.width - kPBMoreViewColum * kMoreViewButtonWidth) / (kPBMoreViewColum + 1);
    
    self.audioCallButton =[PBMoreViewButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(inset, kMoreViewTopPadding, kMoreViewButtonWidth, kMoreViewButtonWidth)];
    _audioCallButton.subTitleLabel.text = NSLocalizedString(@"语音通话", nil);
    
    [_audioCallButton setImage:[UIImage imageNamed:@"dianhua"]
                      forState:UIControlStateNormal];
    [_audioCallButton setImage:[UIImage imageNamed:@"dianhua"]
                      forState:UIControlStateHighlighted];
    
    [_audioCallButton addTarget:self
                         action:@selector(takeAudioCallAction)
               forControlEvents:UIControlEventTouchUpInside];
    _audioCallButton.tag = kPBMoreViewBtnTag;
    [_scrollView addSubview:_audioCallButton];
    
    self.videoCallButton =[PBMoreViewButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(inset * 2 + kMoreViewButtonWidth, kMoreViewTopPadding, kMoreViewButtonWidth, kMoreViewButtonWidth)];
    _videoCallButton.subTitleLabel.text = NSLocalizedString(@"视频通话", nil);
    
    [_videoCallButton setImage:[UIImage imageNamed:@"shipin"]
                      forState:UIControlStateNormal];
    [_videoCallButton setImage:[UIImage imageNamed:@"shipin"]
                      forState:UIControlStateHighlighted];
    
    [_videoCallButton addTarget:self
                         action:@selector(takeVideoCallAction)
               forControlEvents:UIControlEventTouchUpInside];
    _videoCallButton.tag = kPBMoreViewBtnTag + 1;
    [_scrollView addSubview:_videoCallButton];
    
    self.photoButton = [PBMoreViewButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(inset * 3 + kMoreViewButtonWidth * 2, kMoreViewTopPadding, kMoreViewButtonWidth, kMoreViewButtonWidth)];
    _photoButton.subTitleLabel.text = NSLocalizedString(@"图片", nil);
    
    [_photoButton setImage:[UIImage imageNamed:@"tupian"]
                  forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"tupian"]
                  forState:UIControlStateHighlighted];
    [_photoButton addTarget:self
                     action:@selector(photoButtonAction)
           forControlEvents:UIControlEventTouchUpInside];
    _photoButton.tag = kPBMoreViewBtnTag + 2;
    [_scrollView addSubview:_photoButton];
    
    self.takePicButton = [PBMoreViewButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(inset * 4 + kMoreViewButtonWidth * 3, kMoreViewTopPadding, kMoreViewButtonWidth, kMoreViewButtonWidth)];
    _takePicButton.subTitleLabel.text = NSLocalizedString(@"拍照", nil);
    
    [_takePicButton setImage:[UIImage imageNamed:@"zhaopian"]
                    forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"zhaopian"]
                    forState:UIControlStateHighlighted];
    [_takePicButton addTarget:self
                       action:@selector(takePicButtonAction)
             forControlEvents:UIControlEventTouchUpInside];
    _takePicButton.tag = kPBMoreViewBtnTag + 3;
    [_scrollView addSubview:_takePicButton];
    
    self.rewardButton = [PBMoreViewButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(inset, kMoreViewButtonWidth + kMoreViewTopPadding + kMoreViewBottomPadding, kMoreViewButtonWidth, kMoreViewButtonWidth)];
    _rewardButton.subTitleLabel.text = NSLocalizedString(@"打赏", nil);
    
    [_rewardButton setImage:[UIImage imageNamed:@"dashang"]
                     forState:UIControlStateNormal];
    [_rewardButton setImage:[UIImage imageNamed:@"dashang"]
                     forState:UIControlStateHighlighted];
    [_rewardButton addTarget:self
                        action:@selector(rewardButtonAction)
              forControlEvents:UIControlEventTouchUpInside];
    _locationButton.tag = kPBMoreViewBtnTag + 4;
    [_scrollView addSubview:_rewardButton];
    
    self.locationButton = [PBMoreViewButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(inset * 2 + kMoreViewButtonWidth, kMoreViewButtonWidth + kMoreViewTopPadding + kMoreViewBottomPadding, kMoreViewButtonWidth, kMoreViewButtonWidth)];
    _locationButton.subTitleLabel.text = NSLocalizedString(@"位置", nil);
    
    [_locationButton setImage:[UIImage imageNamed:@"weizhi"]
                     forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"weizhi"]
                     forState:UIControlStateHighlighted];
    [_locationButton addTarget:self
                        action:@selector(locationButtonAction)
              forControlEvents:UIControlEventTouchUpInside];
    _locationButton.tag = kPBMoreViewBtnTag + 5;
    [_scrollView addSubview:_locationButton];
    
    self.cardButton = [PBMoreViewButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(inset * 3 + kMoreViewButtonWidth * 2, kMoreViewButtonWidth + kMoreViewTopPadding + kMoreViewBottomPadding, kMoreViewButtonWidth, kMoreViewButtonWidth)];
    _cardButton.subTitleLabel.text = NSLocalizedString(@"名片", nil);
    
    [_cardButton setImage:[UIImage imageNamed:@"mingpian"]
                     forState:UIControlStateNormal];
    [_cardButton setImage:[UIImage imageNamed:@"mingpian"]
                     forState:UIControlStateHighlighted];
    [_cardButton addTarget:self
                    action:@selector(cardButtonAction)
              forControlEvents:UIControlEventTouchUpInside];
    _cardButton.tag = kPBMoreViewBtnTag + 6;
    [_scrollView addSubview:_cardButton];
    
    //记录最大tag值
    _maxIndex = 6;

    CGRect frame = self.frame;
    frame.size.height = kMoreViewButtonWidth * kPBMoreViewRow + kMoreViewBottomPadding * kPBMoreViewRow + kMoreViewTopPadding;
    self.frame = frame;
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20 * ([UIScreen mainScreen].bounds.size.height / 667), CGRectGetWidth(frame), 20 * ([UIScreen mainScreen].bounds.size.height / 667));
    _pageControl.hidden = _pageControl.numberOfPages <= 1;
}

#pragma mark - External interface

- (void)insertItemWithImage:(UIImage *)image
           highlightedImage:(UIImage *)highLightedImage
                      title:(NSString *)title {
    
    CGFloat inset = (self.frame.size.width - kPBMoreViewColum * kMoreViewButtonWidth) / 5;
    CGRect frame = self.frame;
    _maxIndex++;
    NSInteger pageSize = kPBMoreViewColum * kPBMoreViewRow;
    NSInteger page = _maxIndex / pageSize;
    NSInteger row = (_maxIndex % pageSize) / kPBMoreViewColum;
    NSInteger col = _maxIndex % kPBMoreViewColum;
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(page * CGRectGetWidth(self.frame) + inset * (col + 1) + kMoreViewButtonWidth * col,
                                  kMoreViewButtonWidth * row + kMoreViewBottomPadding * (row - 1) + kMoreViewTopPadding,
                                  kMoreViewButtonWidth,
                                  kMoreViewButtonWidth);
    [moreButton setImage:image forState:UIControlStateNormal];
    if (highLightedImage != nil) {
        [moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    }
    [moreButton addTarget:self
                   action:@selector(moreAction:)
         forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = kPBMoreViewBtnTag + _maxIndex;
    [_scrollView addSubview:moreButton];
    
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
    [_pageControl setNumberOfPages:page + 1];
    
    frame.size.height = kMoreViewButtonWidth * kPBMoreViewRow + kMoreViewBottomPadding * (row - 1) + kMoreViewTopPadding;
    self.frame = frame;
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20 * ([UIScreen mainScreen].bounds.size.height / 667), CGRectGetWidth(frame), 20 * ([UIScreen mainScreen].bounds.size.height / 667));
    _pageControl.hidden = _pageControl.numberOfPages <= 1;
}

//更改按钮
- (void)updateItemWithImage:(UIImage *)image
           highlightedImage:(UIImage *)highLightedImage
                      title:(NSString *)title
                    atIndex:(NSInteger)index {
    
    UIView *moreButton = [_scrollView viewWithTag:kPBMoreViewBtnTag + index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        
        [(UIButton*)moreButton setImage:image forState:UIControlStateNormal];
        
        if (highLightedImage != nil) {
            [(UIButton*)moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
        }
    }
}

//移除按钮
- (void)removeItemWithIndex:(NSInteger)index {
    
    UIView *moreButton = [_scrollView viewWithTag:kPBMoreViewBtnTag + index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        [self resetItemWithIndex:index];
        [moreButton removeFromSuperview];
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset =  scrollView.contentOffset;
    if (offset.x == 0) {
        _pageControl.currentPage = 0;
    } else {
        int page = offset.x / CGRectGetWidth(scrollView.frame);
        _pageControl.currentPage = page;
    }
}

#pragma mark - setter

- (void)setMoreViewBackgroundColor:(UIColor *)moreViewBackgroundColor {
    _moreViewBackgroundColor = moreViewBackgroundColor;
    if (_moreViewBackgroundColor) {
        [self setBackgroundColor:_moreViewBackgroundColor];
    }
}

#pragma mark - action

//相册选取图片
- (void)photoButtonAction {
    [self.superview endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}
//拍照
- (void)takePicButtonAction {
    [self.superview endEditing:YES];
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}
//定位
- (void)locationButtonAction {
    [self.superview endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}
//语音通话
- (void)takeAudioCallAction {
    [self.superview endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}
//视频通话
- (void)takeVideoCallAction {
    [self.superview endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}
//名片功能
- (void)cardButtonAction {
    [self.superview endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewCardButtonAction:)]) {
        [_delegate moreViewCardButtonAction:self];
    }
}
//打赏
- (void)rewardButtonAction {
    [self.superview endEditing:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewRewardButtonAction:)]) {
        [_delegate moreViewRewardButtonAction:self];
    }
}
//自定义按钮点击事件
- (void)moreAction:(UIButton *)sender {
    UIButton *button = (UIButton*)sender;
    [self.superview endEditing:YES];
    if (button && _delegate && [_delegate respondsToSelector:@selector(moreView:didItemInMoreViewWithIndex:)]) {
        [_delegate moreView:self didItemInMoreViewWithIndex:button.tag - kPBMoreViewBtnTag];
    }
}

#pragma mark - Tool mothed

//移除按钮具体方法
- (void)resetItemWithIndex:(NSInteger)index {
    
    CGFloat inset = (self.frame.size.width - kPBMoreViewColum * kMoreViewButtonWidth) / 5;
    CGRect frame = self.frame;
    
    for (NSInteger i = index + 1; i < _maxIndex + 1; i++) {
        
        UIView *moreButton = [_scrollView viewWithTag:kPBMoreViewBtnTag + i];
        if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
            NSInteger moveToIndex = i - 1;
            NSInteger pageSize = kPBMoreViewColum * kPBMoreViewRow;
            NSInteger page = moveToIndex / pageSize;
            NSInteger row = (moveToIndex % pageSize) / kPBMoreViewColum;
            NSInteger col = moveToIndex % kPBMoreViewColum;
            
            [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + inset * (col + 1) + kMoreViewButtonWidth * col,
                                            kMoreViewButtonWidth * row + kMoreViewBottomPadding * (row - 1) + kMoreViewTopPadding,
                                            kMoreViewButtonWidth ,
                                            kMoreViewButtonWidth)];
            
            moreButton.tag = kPBMoreViewBtnTag + moveToIndex;
            [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1),
                                                   CGRectGetHeight(self.frame))];
            [_pageControl setNumberOfPages:page + 1];
        }
    }
    
    _maxIndex--;
    frame.size.height = kMoreViewButtonWidth * kPBMoreViewRow + kMoreViewBottomPadding * kPBMoreViewRow + kMoreViewTopPadding;
    self.frame = frame;
    _scrollView.frame = CGRectMake(0,
                                   0,
                                   CGRectGetWidth(frame),
                                   CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0,
                                    CGRectGetHeight(frame) - 20 * ([UIScreen mainScreen].bounds.size.height / 667),
                                    CGRectGetWidth(frame),
                                    20 * ([UIScreen mainScreen].bounds.size.height / 667));
    _pageControl.hidden = _pageControl.numberOfPages <= 1;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
