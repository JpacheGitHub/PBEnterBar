//
//  PBMoreView.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBMoreView.h"

//button大小
#define BUTTONSIZE (60 * (ONEWIDTH))
//button.tag 初始值
#define BUTTONTAG 10000
//列数
#define MOREVIEW_COL 4
//行数
#define MOREVIEW_ROW 2

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
@property (nonatomic, strong) UIButton *photoButton;
/**
 *  照相
 */
@property (nonatomic, strong) UIButton *takePicButton;
/**
 *  定位
 */
@property (nonatomic, strong) UIButton *locationButton;
/**
 *  语音通话
 */
@property (nonatomic, strong) UIButton *audioCallButton;
/**
 *  视频通话
 */
@property (nonatomic, strong) UIButton *videoCallButton;

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
    
    CGFloat inset = (self.frame.size.width - MOREVIEW_COL * BUTTONSIZE) / 5;
    
    self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoButton.frame = CGRectMake(inset, inset, BUTTONSIZE, BUTTONSIZE);
    
    [_photoButton setBackgroundImage:[UIImage imageNamed:@"sharemore_otherDown@3x"]
                            forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"sharemore_pic@3x"]
                  forState:UIControlStateNormal];
    [_photoButton setBackgroundImage:[UIImage imageNamed:@"sharemore_other_HL@3x"]
                            forState:UIControlStateHighlighted];
    [_photoButton setImage:[UIImage imageNamed:@"sharemore_pic@3x"]
                  forState:UIControlStateHighlighted];
    
    [_photoButton addTarget:self
                     action:@selector(photoButtonAction)
           forControlEvents:UIControlEventTouchUpInside];
    _photoButton.tag = BUTTONTAG;
    [_scrollView addSubview:_photoButton];
    
    self.takePicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _takePicButton.frame = CGRectMake(inset * 2 + BUTTONSIZE, inset, BUTTONSIZE, BUTTONSIZE);
    
    [_takePicButton setBackgroundImage:[UIImage imageNamed:@"sharemore_otherDown@3x"]
                              forState:UIControlStateNormal];
    [_takePicButton setImage:[UIImage imageNamed:@"sharemore_video@3x"]
                    forState:UIControlStateNormal];
    [_takePicButton setBackgroundImage:[UIImage imageNamed:@"sharemore_other_HL@3x"]
                              forState:UIControlStateHighlighted];
    [_takePicButton setImage:[UIImage imageNamed:@"sharemore_video@3x"]
                    forState:UIControlStateHighlighted];
    
    [_takePicButton addTarget:self
                       action:@selector(takePicButtonAction)
             forControlEvents:UIControlEventTouchUpInside];
    _takePicButton.tag = BUTTONTAG + 1;
    [_scrollView addSubview:_takePicButton];
    
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(inset * 3 + BUTTONSIZE * 2, inset, BUTTONSIZE, BUTTONSIZE);
    
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"sharemore_otherDown@3x"]
                               forState:UIControlStateNormal];
    [_locationButton setImage:[UIImage imageNamed:@"sharemore_location@3x"]
                     forState:UIControlStateNormal];
    [_locationButton setBackgroundImage:[UIImage imageNamed:@"sharemore_other_HL@3x"]
                               forState:UIControlStateHighlighted];
    [_locationButton setImage:[UIImage imageNamed:@"sharemore_location@3x"]
                     forState:UIControlStateHighlighted];
    
    [_locationButton addTarget:self
                        action:@selector(locationButtonAction)
              forControlEvents:UIControlEventTouchUpInside];
    _locationButton.tag = BUTTONTAG + 2;
    [_scrollView addSubview:_locationButton];
    //记录最大tag值
    _maxIndex = 2;
    
    
    if (type == PBEnterbarTypeChat) {
        
        self.audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_audioCallButton setFrame:CGRectMake(inset * 4 + BUTTONSIZE * 3, inset, BUTTONSIZE , BUTTONSIZE)];
        
        [_audioCallButton setBackgroundImage:[UIImage imageNamed:@"sharemore_otherDown@3x"]
                                    forState:UIControlStateNormal];
        [_audioCallButton setImage:[UIImage imageNamed:@"sharemore_voiceinput@3x"]
                          forState:UIControlStateNormal];
        [_audioCallButton setBackgroundImage:[UIImage imageNamed:@"sharemore_other_HL@3x"]
                                    forState:UIControlStateHighlighted];
        [_audioCallButton setImage:[UIImage imageNamed:@"sharemore_voiceinput@3x"]
                          forState:UIControlStateHighlighted];
        
        [_audioCallButton addTarget:self
                             action:@selector(takeAudioCallAction)
                   forControlEvents:UIControlEventTouchUpInside];
        _audioCallButton.tag = BUTTONTAG + 3;
        [_scrollView addSubview:_audioCallButton];
        
        self.videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_videoCallButton setFrame:CGRectMake(inset, inset * 2 + BUTTONSIZE, BUTTONSIZE , BUTTONSIZE)];
        
        [_videoCallButton setBackgroundImage:[UIImage imageNamed:@"sharemore_otherDown@3x"]
                                    forState:UIControlStateNormal];
        [_videoCallButton setImage:[UIImage imageNamed:@"sharemore_videovoip@3x"]
                          forState:UIControlStateNormal];
        [_videoCallButton setBackgroundImage:[UIImage imageNamed:@"sharemore_other_HL@3x"]
                                    forState:UIControlStateHighlighted];
        [_videoCallButton setImage:[UIImage imageNamed:@"sharemore_videovoip@3x"]
                          forState:UIControlStateHighlighted];
        
        [_videoCallButton addTarget:self
                             action:@selector(takeVideoCallAction)
                   forControlEvents:UIControlEventTouchUpInside];
        _videoCallButton.tag = BUTTONTAG + 4;
        [_scrollView addSubview:_videoCallButton];
        _maxIndex = 4;
    }
    CGRect frame = self.frame;
    frame.size.height = BUTTONSIZE * 2 + inset * 3;
    self.frame = frame;
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20 * ONEHEIGHT, CGRectGetWidth(frame), 20 * ONEHEIGHT);
    _pageControl.hidden = _pageControl.numberOfPages <= 1;
}

#pragma mark - External interface

- (void)insertItemWithImage:(UIImage *)image
           highlightedImage:(UIImage *)highLightedImage
                      title:(NSString *)title {
    
    CGFloat inset = (self.frame.size.width - MOREVIEW_COL * BUTTONSIZE) / 5;
    CGRect frame = self.frame;
    _maxIndex++;
    NSInteger pageSize = MOREVIEW_COL * MOREVIEW_ROW;
    NSInteger page = _maxIndex / pageSize;
    NSInteger row = (_maxIndex % pageSize) / MOREVIEW_COL;
    NSInteger col = _maxIndex % MOREVIEW_COL;
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(page * CGRectGetWidth(self.frame) + inset * (col + 1) + BUTTONSIZE * col,
                                  inset + inset * row + BUTTONSIZE * row,
                                  BUTTONSIZE,
                                  BUTTONSIZE);
    [moreButton setImage:image forState:UIControlStateNormal];
    if (highLightedImage != nil) {
        [moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
    }
    [moreButton addTarget:self
                   action:@selector(moreAction:)
         forControlEvents:UIControlEventTouchUpInside];
    moreButton.tag = BUTTONTAG + _maxIndex;
    [_scrollView addSubview:moreButton];
    
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1), CGRectGetHeight(self.frame))];
    [_pageControl setNumberOfPages:page + 1];
    
    frame.size.height = BUTTONSIZE * 2 + inset * 3;
    self.frame = frame;
    _scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 20 * ONEHEIGHT, CGRectGetWidth(frame), 20 * ONEHEIGHT);
    _pageControl.hidden = _pageControl.numberOfPages <= 1;
}

//更改按钮
- (void)updateItemWithImage:(UIImage *)image
           highlightedImage:(UIImage *)highLightedImage
                      title:(NSString *)title
                    atIndex:(NSInteger)index {
    
    UIView *moreButton = [_scrollView viewWithTag:BUTTONTAG + index];
    if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
        
        [(UIButton*)moreButton setImage:image forState:UIControlStateNormal];
        
        if (highLightedImage != nil) {
            [(UIButton*)moreButton setImage:highLightedImage forState:UIControlStateHighlighted];
        }
    }
}

//移除按钮
- (void)removeItemWithIndex:(NSInteger)index {
    
    UIView *moreButton = [_scrollView viewWithTag:BUTTONTAG + index];
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
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}
//拍照
- (void)takePicButtonAction {
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}
//定位
- (void)locationButtonAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}
//语音通话
- (void)takeAudioCallAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}
//视频通话
- (void)takeVideoCallAction {
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}
//自定义按钮点击事件
- (void)moreAction:(UIButton *)sender {
    UIButton *button = (UIButton*)sender;
    if (button && _delegate && [_delegate respondsToSelector:@selector(moreView:didItemInMoreViewWithIndex:)]) {
        [_delegate moreView:self didItemInMoreViewWithIndex:button.tag - BUTTONTAG];
    }
}

#pragma mark - Tool mothed

//移除按钮具体方法
- (void)resetItemWithIndex:(NSInteger)index {
    
    CGFloat inset = (self.frame.size.width - MOREVIEW_COL * BUTTONSIZE) / 5;
    CGRect frame = self.frame;
    
    for (NSInteger i = index + 1; i < _maxIndex + 1; i++) {
        
        UIView *moreButton = [_scrollView viewWithTag:BUTTONTAG + i];
        if (moreButton && [moreButton isKindOfClass:[UIButton class]]) {
            NSInteger moveToIndex = i - 1;
            NSInteger pageSize = MOREVIEW_COL * MOREVIEW_ROW;
            NSInteger page = moveToIndex / pageSize;
            NSInteger row = (moveToIndex % pageSize) / MOREVIEW_COL;
            NSInteger col = moveToIndex % MOREVIEW_COL;
            
            [moreButton setFrame:CGRectMake(page * CGRectGetWidth(self.frame) + inset * (col + 1) + BUTTONSIZE * col,
                                            inset + inset * row + BUTTONSIZE * row,
                                            BUTTONSIZE ,
                                            BUTTONSIZE)];
            
            moreButton.tag = BUTTONTAG + moveToIndex;
            [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * (page + 1),
                                                   CGRectGetHeight(self.frame))];
            [_pageControl setNumberOfPages:page + 1];
        }
    }
    
    _maxIndex--;
    frame.size.height = BUTTONSIZE * 2 + inset * 3;
    self.frame = frame;
    _scrollView.frame = CGRectMake(0,
                                   0,
                                   CGRectGetWidth(frame),
                                   CGRectGetHeight(frame));
    _pageControl.frame = CGRectMake(0,
                                    CGRectGetHeight(frame) - 20 * ONEHEIGHT,
                                    CGRectGetWidth(frame),
                                    20 * ONEHEIGHT);
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
