//
//  NSAttributedString+PBEmojiExtension.h
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/21.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (PBEmojiExtension)
/**
 *  带表情的消息时发送不出去的，此方法解决此问题，转换成对应的文字
 *
 *  @return 表情所对应的文字
 */
- (NSString *)getPlainString;

@end
