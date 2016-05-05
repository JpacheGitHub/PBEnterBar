//
//  PBEmojiManager.h
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/21.
//  Copyright © 2015年 Jpache. All rights reserved.
//
/*
 表情处理类，当文本中需要有表情显示时，使用此类进行处理
 */
#import <Foundation/Foundation.h>
#import "PBEmojiTextAttchment.h"
#import "NSAttributedString+PBEmojiExtension.h"

@interface PBEmojiManager : NSObject

@property (nonatomic, strong) NSDictionary *emojiDic;


+ (instancetype)shareManager;
/**
 *  获取所有表情图片
 *
 *  @return 表情数组
 */
+ (NSArray *)allEmoji;
/**
 *  获取所有表情对应文本
 *
 *  @return 表情文本数组
 */
+ (NSArray *)allEmojiTitle;
/**
 *  显示消息中若可能有表情，使用此方法转义
 *
 *  @param container 显示容器
 *  @param str       消息体
 *
 *  @return 可显示表情的NSAttributedString
 */
+ (NSAttributedString *)convertStringWithContainer:(UILabel *)container string:(NSString *)str;

@end
