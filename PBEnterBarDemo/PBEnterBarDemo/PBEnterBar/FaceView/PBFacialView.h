//
//  PBFacialView.h
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/21.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBFacialViewDelegate <NSObject>
/**
 *  点击表情代理方法
 *
 *  @param emojiTitle 当前选中表情的标题
 *  @param isDelete   是否是删除键
 */
- (void)selectedFacialView:(NSString*)emojiTitle faceImage:(UIImage *)image isDelete:(BOOL)isDelete;

- (void)sendFaceButtonAction:(UIButton *)sender;

@end

@interface PBFacialView : UIView

@property (nonatomic, assign) id<PBFacialViewDelegate> delegate;

@end
