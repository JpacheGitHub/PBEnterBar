//
//  PBEnterBarHeader.h
//  PBEnterBarDemo
//
//  Created by Jpache on 16/5/5.
//  Copyright © 2016年 Jpache. All rights reserved.
//

#ifndef PBEnterBarHeader_h
#define PBEnterBarHeader_h

//屏幕宽度
#define kWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kHeight [UIScreen mainScreen].bounds.size.height
//适配用, iPhone6中为一倍宽
#define ONEWIDTH ([UIScreen mainScreen].bounds.size.width / 375)
//适配用, iPhone6中为一倍高
#define ONEHEIGHT ([UIScreen mainScreen].bounds.size.height / 667)

typedef NS_ENUM(NSInteger, PBEnterBarType) {
    PBEnterbarTypeChat,                //私聊类型
    PBEnterbarTypeGroup,               //群聊类型
    PBEnterbarTypeComment,             //评论类型
};

typedef NS_ENUM(NSInteger, PBRecordViewType) {
    PBRecordViewTypeTouchDown,                 //按下录音键
    PBRecordViewTypeTouchUpInside,             //在录音键内部松开录音键
    PBRecordViewTypeTouchUpOutside,            //在录音键外部松开录音键
    PBRecordViewTypeDragInside,                //手指移动到录音键内部
    PBRecordViewTypeDragOutside,               //手指移动到录音键外部
};

#endif /* PBEnterBarHeader_h */
