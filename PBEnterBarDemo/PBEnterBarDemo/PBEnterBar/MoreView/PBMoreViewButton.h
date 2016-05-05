//
//  PBMoreViewButton.h
//  SayPal
//
//  Created by Jpache on 15/12/31.
//  Copyright © 2015年 cusflo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBMoreViewButton : UIButton

@property (nonatomic, strong) UILabel *subTitleLabel;

+ (instancetype)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame;

@end
