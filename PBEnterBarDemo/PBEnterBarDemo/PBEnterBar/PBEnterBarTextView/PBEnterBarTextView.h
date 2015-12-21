//
//  PBEnterBarTextView.h
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBEnterBarTextView : UITextView

/**
 *  获取自身文本占据有多少行
 *
 *  @return 返回行数
 */
- (NSUInteger)numberOfLinesOfText;
/**
 *  获取每行的高度
 *
 *  @return 根据iPhone或者iPad来获取每行字体的高度
 */
+ (NSUInteger)maxCharactersPerLine;
/**
 *  获取某个文本占据自身适应宽带的行数
 *
 *  @param text 目标文本
 *
 *  @return 返回占据行数
 */
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

@end
