//
//  NSAttributedString+PBEmojiExtension.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/21.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "NSAttributedString+PBEmojiExtension.h"
#import "PBEmojiTextAttchment.h"

@implementation NSAttributedString (PBEmojiExtension)

- (NSString *)getPlainString {
    //最终纯文本
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    //遍历
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      //检查类型是否是自定义NSTextAttachment类
                      if (value && [value isKindOfClass:[PBEmojiTextAttchment class]]) {
                          //替换
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((PBEmojiTextAttchment *) value).emojiTitle];
                          
                          //增加偏移量
                          base += ((PBEmojiTextAttchment *) value).emojiTitle.length - 1;
                      }
                  }];
    return plainString;
}

@end
