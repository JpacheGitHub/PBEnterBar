//
//  PBRecordView.h
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBRecordViewDelegate <NSObject>

/**
 *  设置显示音量大小图片
 *
 *  @param recordAnimationView         显示音量的ImageView
 *  @param voiceMessageAnimationImages 存放音量大小的图片的数组
 */
- (void)setRecordingVoiceImage:(UIImageView *)recordAnimationView
                         array:(NSArray *)voiceMessageAnimationImages;

@end

@interface PBRecordView : UIView

@property (nonatomic, assign) id<PBRecordViewDelegate> delegate;
/**
 *  存放音量大小图片的数组
 */
@property (nonatomic, strong) NSArray *voiceMessageAnimationImages;
/**
 *  提示手指上划可取消录音
 */
@property (nonatomic, copy) NSString *upCancelText;
/**
 *  手指移出录音按钮后现实文字提示
 */
@property (nonatomic, copy) NSString *loosenCancelText;

/**
 *  录音按钮按下
 */
-(void)recordButtonTouchDown;
/**
 *  手指在录音按钮内部时离开
 */
-(void)recordButtonTouchUpInside;
/**
 *  手指在录音按钮外部时离开
 */
-(void)recordButtonTouchUpOutside;
/**
 *  手指移动到录音按钮内部
 */
-(void)recordButtonDragInside;
/**
 *  手指移动到录音按钮外部
 */
-(void)recordButtonDragOutside;

@end
