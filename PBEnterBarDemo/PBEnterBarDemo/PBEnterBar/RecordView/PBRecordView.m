//
//  PBRecordView.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBRecordView.h"

@interface PBRecordView ()


@property (nonatomic, strong) NSTimer *timer;
/**
 *  显示动画的ImageView
 */
@property (nonatomic, strong) UIImageView *recordAnimationView;
/**
 *  提示文字
 */
@property (nonatomic, strong) UILabel *textLabel;
/**
 *  显示的麦克风
 */
@property (nonatomic, strong) UIImageView *recordingImage;
/**
 *  取消发送的图片
 */
@property (nonatomic, strong) UIImageView *cancelImage;

@end

@implementation PBRecordView

+ (void)initialize {
    // UIAppearance Proxy Defaults
    PBRecordView *recordView = [self appearance];
    recordView.voiceMessageAnimationImages = @[@"RecordingSignal001@3x", @"RecordingSignal002@3x", @"RecordingSignal003@3x", @"RecordingSignal004@3x", @"RecordingSignal005@3x", @"RecordingSignal006@3x", @"RecordingSignal007@3x", @"RecordingSignal008@3x",];
    recordView.upCancelText = @"手指上划, 取消发送";
    recordView.loosenCancelText = @"松开手指, 取消发送";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        bgView.alpha = 0.6;
        [self addSubview:bgView];
        
        self.recordingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RecordingBkg@3x"]];
        _recordingImage.frame = CGRectMake(10,
                                           0,
                                           (self.frame.size.width - 20) / 2,
                                           self.frame.size.height - 30);
        _recordingImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordingImage];
        
        self.recordAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2,
                                                                                 0,
                                                                                 (self.frame.size.width - 20) / 2,
                                                                                 self.bounds.size.height - 30)];
        _recordAnimationView.image = [UIImage imageNamed:@"RecordingSignal001@3x"];
        _recordAnimationView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_recordAnimationView];
        
        self.cancelImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RecordCancel@3x"]];
        _cancelImage.frame = CGRectMake(10,
                                        0,
                                        self.frame.size.width - 20,
                                        self.frame.size.height - 30);
        _cancelImage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                                   self.bounds.size.height - 30,
                                                                   self.bounds.size.width - 10,
                                                                   25)];
        
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.text = @"这是提示";
        [self addSubview:_textLabel];
        _textLabel.font = [UIFont systemFontOfSize:13];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.layer.cornerRadius = 5;
        _textLabel.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        _textLabel.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - setter

- (void)setVoiceMessageAnimationImages:(NSArray *)voiceMessageAnimationImages {
    _voiceMessageAnimationImages = voiceMessageAnimationImages;
}

- (void)setUpCancelText:(NSString *)upCancelText {
    _upCancelText = upCancelText;
    _textLabel.text = _upCancelText;
}

- (void)setLoosenCancelText:(NSString *)loosenCancelText {
    _loosenCancelText = loosenCancelText;
}

#pragma mark - action

// 按下录音按钮
- (void)recordButtonTouchDown {
    if ([_cancelImage superview]) {
        [_cancelImage removeFromSuperview];
    }
    [self addSubview:_recordingImage];
    [self addSubview:_recordAnimationView];
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                  target:self
                                                selector:@selector(setVoiceImage)
                                                userInfo:nil
                                                 repeats:YES];
}

// 在录音按钮内部离开时
- (void)recordButtonTouchUpInside {
    if ([_cancelImage superview]) {
        [_cancelImage removeFromSuperview];
    }
    [self addSubview:_recordingImage];
    [self addSubview:_recordAnimationView];
    [_timer invalidate];
}

// 在录音按钮外部离开时
- (void)recordButtonTouchUpOutside {
    if ([_cancelImage superview]) {
        [_cancelImage removeFromSuperview];
    }
    [self addSubview:_recordingImage];
    [self addSubview:_recordAnimationView];
    [_timer invalidate];
}

// 手指移动到录音按钮内部
- (void)recordButtonDragInside {
    if ([_cancelImage superview]) {
        [_cancelImage removeFromSuperview];
    }
    [self addSubview:_recordingImage];
    [self addSubview:_recordAnimationView];
    _textLabel.text = _upCancelText;
    _textLabel.backgroundColor = [UIColor clearColor];
}

// 手指移动到录音按钮外部
- (void)recordButtonDragOutside {
    [_recordAnimationView removeFromSuperview];
    [_recordingImage removeFromSuperview];
    [self addSubview:_cancelImage];
    _textLabel.text = _loosenCancelText;
    _textLabel.backgroundColor = [UIColor redColor];
}

#pragma mark - private

- (void)setVoiceImage {
    if (_delegate && [_delegate respondsToSelector:@selector(setRecordingVoiceImage:array:)]) {
        [_delegate setRecordingVoiceImage:_recordAnimationView
                                    array:_voiceMessageAnimationImages];
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
