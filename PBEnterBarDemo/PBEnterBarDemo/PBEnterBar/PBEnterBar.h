//
//  PBEnterBar.h
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBEnterBarDefine.h"

@class PBFaceView, PBMoreView, PBRecordView, PBEnterBarTextView;

@protocol PBEnterBarDelegate;
@interface PBEnterBar : UIView

@property (nonatomic, assign) id<PBEnterBarDelegate> delegate;

@property (nonatomic, strong) UIView *enterBarView;
@property (nonatomic, copy) NSString *defaultImageName;
@property (nonatomic, copy) NSString *defaultHLImageName;
/**
 *  输入框
 */
@property (nonatomic, strong) PBEnterBarTextView *inputTextView;
/**
 *  附加功能按钮
 */
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, copy) NSString *moreImageName;
@property (nonatomic, copy) NSString *moreHLImageName;
/**
 *  表情按钮
 */
@property (nonatomic, strong) UIButton *faceButton;
@property (nonatomic, copy) NSString *faceImageName;
@property (nonatomic, copy) NSString *faceHLImageName;
/**
 *  语音按钮
 */
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, copy) NSString *recordImageName;
@property (nonatomic, copy) NSString *recordHLImageName;
/**
 *  表情页
 */
@property (nonatomic, strong) PBFaceView *faceView;
/**
 *  附加功能页
 */
@property (nonatomic, strong) PBMoreView *moreView;
/**
 *  录音页
 */
@property (nonatomic, strong) PBRecordView *recordView;
/**
 *  enterBar类型
 */
@property (nonatomic, assign) PBEnterBarType enterBarType;
/**
 *  输入框最大高度
 */
@property (nonatomic, assign, readonly) CGFloat inputViewMaxHeight;
/**
 *  输入框最小高度
 */
@property (nonatomic, assign, readonly) CGFloat inputViewMinHeight;
/**
 *  横向边距
 */
@property (nonatomic, assign, readonly) CGFloat horizontalPadding;
/**
 *  纵向边距
 */
@property (nonatomic, assign, readonly) CGFloat verticalPadding;

/**
 *  初始化方法
 *
 *  @param frame              视图位置信息
 *  @param horizontalPadding  横向边距, 默认5
 *  @param verticalPadding    纵向间距, 默认5
 *  @param inputViewMinHeight 输入框最小高度, 默认36
 *  @param inputViewMaxHeight 输入框最大高度, 默认150
 *  @param type               enterBar类型, 默认群聊类型
 *
 *  @return enterBar
 */

- (instancetype)init;

- (instancetype)initWithType:(PBEnterBarType)type;

- (instancetype)initWithHorizontalPadding:(CGFloat)horizontalPadding
                          verticalPadding:(CGFloat)verticalPadding
                       inputViewMinHeight:(CGFloat)inputViewMinHeight
                       inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                                     type:(PBEnterBarType)type;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(PBEnterBarType)type;

- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                         type:(PBEnterBarType)type;

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;

/**
 *  取消触摸录音键
 */
- (void)cancelTouchRecord;

@end



@protocol PBEnterBarDelegate <NSObject>

@required

#pragma mark - chatBar
/**
 *  高度变到toHeight
 */
- (void)enterBarDidChangeFrameToHeight:(CGFloat)toHeight;

@optional

#pragma mark - textView
/**
 *  文字输入框开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewDidBeginEditing:(PBEnterBarTextView *)inputTextView;

/**
 *  文字输入框将要开始编辑
 *
 *  @param inputTextView 输入框对象
 */
- (void)inputTextViewWillBeginEditing:(PBEnterBarTextView *)inputTextView;
/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;
/**
 *  发送第三方表情，不会添加到文字输入框中
 *
 *  @param faceLocalPath 选中的表情的本地路径
 */
- (void)didSendFace:(NSString *)faceLocalPath;

#pragma mark - record

/**
 *  按下录音按钮开始录音, 会自动判断是否允许使用麦克风, 如果不允许, 则按下按钮也不会触发代理
 */
- (void)didStartRecordingVoiceAction:(PBRecordView *)recordView;
/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(PBRecordView *)recordView;
/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(PBRecordView *)recordView;
/**
 *  当手指离开按钮的范围内时，主要为了通知外部的HUD
 */
- (void)didDragOutsideAction:(PBRecordView *)recordView;
/**
 *  当手指再次进入按钮的范围内时，主要也是为了通知外部的HUD
 */
- (void)didDragInsideAction:(PBRecordView *)recordView;

@end
