//
//  PBEnterBarHelper.m
//  PBEnterBarDemo
//
//  Created by Jpache on 2016/11/2.
//  Copyright © 2016年 Jpache. All rights reserved.
//

#import "PBEnterBarHelper.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation PBEnterBarHelper

//是否可用录音功能
+ (BOOL)canRecord {
    __block BOOL bCanRecord = YES;
    
     [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
         
         if (granted) {
             bCanRecord = YES;
         }else {
             bCanRecord = NO;
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@需要访问您的麦克风", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]] message:@"请在\"设置-隐私-麦克风\"中启用麦克风" preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
             
                 }];
                 
                 [alertController addAction:alertAction];
                 [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:^{
                     
                 }];
             });
         }
     }];
     return bCanRecord;
}

@end
