//
//  PBMoreView.h
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PBMoreViewDelegate;
@interface PBMoreView : UIView

@property (nonatomic, assign) id<PBMoreViewDelegate> delegate;
/**
 *  moreView背景颜色
 */
@property (nonatomic, strong) UIColor *moreViewBackgroundColor;   //default is whiteColor

/**
 *  初始化方法
 *
 *  @param frame 位置信息
 *  @param type  初始化类型
 *
 *  @return 附加功能页面
 */
- (instancetype)initWithFrame:(CGRect)frame
                         type:(PBEnterBarType)type;
/**
 *  添加一个按钮
 *
 *  @param image            按钮图片
 *  @param highLightedImage 点击时图片
 *  @param title            按钮标题
 */
- (void)insertItemWithImage:(UIImage *)image
           highlightedImage:(UIImage *)highLightedImage
                      title:(NSString *)title;
/**
 *  根据索引修改按钮图片
 *
 *  @param image            按钮图片
 *  @param highLightedImage 点击时图片
 *  @param title            按钮标题
 *  @param index            索引
 */
- (void)updateItemWithImage:(UIImage*)image
           highlightedImage:(UIImage*)highLightedImage
                      title:(NSString*)title
                    atIndex:(NSInteger)index;
/**
 *  根据索引删除按钮
 *
 *  @param index 索引
 */
- (void)removeItemWithIndex:(NSInteger)index;

@end

@protocol PBMoreViewDelegate <NSObject>

@optional
/**
 *  照相功能键
 *
 *  @param moreView 容器视图
 */
- (void)moreViewTakePicAction:(PBMoreView *)moreView;
/**
 *  相册功能键
 *
 *  @param moreView 容器视图
 */
- (void)moreViewPhotoAction:(PBMoreView *)moreView;
/**
 *  定位功能键
 *
 *  @param moreView 容器视图
 */
- (void)moreViewLocationAction:(PBMoreView *)moreView;
/**
 *  语音功能键
 *
 *  @param moreView 容器视图
 */
- (void)moreViewAudioCallAction:(PBMoreView *)moreView;
/**
 *  视频功能键
 *
 *  @param moreView 容器视图
 */
- (void)moreViewVideoCallAction:(PBMoreView *)moreView;
/**
 *  名片功能
 *
 *  @param moreView 容器视图
 */
- (void)moreViewCardButtonAction:(PBMoreView *)moreView;
/**
 *  打赏功能
 *
 *  @param moreView 视图容器
 */
- (void)moreViewRewardButtonAction:(PBMoreView *)moreView;
/**
 *  自定义功能按钮点击事件
 *
 *  @param moreView 容器视图
 *  @param index    按钮索引
 */
- (void)moreView:(PBMoreView *)moreView didItemInMoreViewWithIndex:(NSInteger)index;

@end