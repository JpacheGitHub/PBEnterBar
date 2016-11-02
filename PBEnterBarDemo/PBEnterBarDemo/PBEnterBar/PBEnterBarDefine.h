//
//  PBEnterBarDefine.h
//  PBEnterBarDemo
//
//  Created by Jpache on 2016/11/2.
//  Copyright © 2016年 Jpache. All rights reserved.
//

#ifndef PBEnterBarDefine_h
#define PBEnterBarDefine_h

typedef NS_ENUM(NSInteger, PBEnterBarType) {
    PBEnterBarTypeChat = 0x01,                //私聊类型
    PBEnterBarTypeGroup = 0x02,               //群聊类型
    PBEnterBarTypeComment = 0x03,             //评论类型
};

typedef NS_ENUM(NSInteger, PBRecordViewType) {
    PBRecordViewTypeTouchDown = 0x01,                 //按下录音键
    PBRecordViewTypeTouchUpInside = 0x02,             //在录音键内部松开录音键
    PBRecordViewTypeTouchUpOutside = 0x03,            //在录音键外部松开录音键
    PBRecordViewTypeDragInside = 0x04,                //手指移动到录音键内部
    PBRecordViewTypeDragOutside = 0x05,               //手指移动到录音键外部
};

#endif /* PBEnterBarDefine_h */
