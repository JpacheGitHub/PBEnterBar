//
//  PBEmojiManager.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/21.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBEmojiManager.h"

@implementation PBEmojiManager

+ (NSArray *)allEmoji {
    NSString *plistStr = [[NSBundle mainBundle]pathForResource:@"expression" ofType:@"plist"];
    NSDictionary *emojiDic = [NSDictionary dictionaryWithContentsOfFile:plistStr];
    NSArray *emojiArray = [NSArray arrayWithArray:[emojiDic allValues]];
    return emojiArray;
}

+ (NSArray *)allEmojiTitle {
    NSString *plistStr = [[NSBundle mainBundle]pathForResource:@"expression" ofType:@"plist"];
    NSDictionary *emojiDic = [NSDictionary dictionaryWithContentsOfFile:plistStr];
    NSArray *emojiTitleArray = [NSArray arrayWithArray:[emojiDic allKeys]];
    return emojiTitleArray;
}

+ (NSAttributedString *)convertStringWithContainer:(UILabel *)container string:(NSString *)str {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSArray *emojiArray = [PBEmojiManager allEmoji];
    NSArray *emojiTitleArray = [PBEmojiManager allEmojiTitle];
    //正则匹配要替换的文字的范围
    //正则表达式
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        //        NSLog(@"%@", [error localizedDescription]);
    }
    
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    //    NSLog(@"resultArray : %@", resultArray);
    
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [str substringWithRange:range];
        
        for (int i = 0; i < emojiTitleArray.count; i ++) {
            if ([emojiTitleArray[i] isEqualToString:subStr]) {
                
                //face[i][@"gif"]就是我们要加载的图片
                //新建文字附件来存放我们的图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //                    CGFloat n = 25/12;
                textAttachment.bounds = CGRectMake(textAttachment.bounds.origin.x, textAttachment.bounds.origin.y - 5, 25, 25);
                
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:[emojiArray objectAtIndex:i]];
                
                CGFloat height = container.font.lineHeight;
                textAttachment.bounds = CGRectMake(0, -5, height + 1, height + 1);
                
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                //把字典存入数组中
                [imageArray addObject:imageDic];
                
            }
        }
    }
    
    //从后往前替换
    for (NSInteger i = imageArray.count - 1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributedString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    [attributedString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]} range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

@end
