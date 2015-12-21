//
//  PBEnterBarItem.h
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBEnterBarItem : UIView

/**
 *  按钮
 */
@property (strong, nonatomic) UIButton *button;
/**
 *  点击按钮之后在toolbar下方延伸出的页面
 */
@property (strong, nonatomic) UIView *button2View;

- (instancetype)initWithButton:(UIButton *)button
                      withView:(UIView *)button2View;

@end
