//
//  PBMoreViewButton.m
//  SayPal
//
//  Created by Jpache on 15/12/31.
//  Copyright © 2015年 cusflo. All rights reserved.
//

#import "PBMoreViewButton.h"

@implementation PBMoreViewButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.7, frame.size.width, frame.size.height * 0.3)];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.textColor = [UIColor colorWithRed:0.7452 green:0.7452 blue:0.7452 alpha:1.0];
        _subTitleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_subTitleLabel];
    }
    return self;
}

+ (instancetype)buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame{
    PBMoreViewButton *button = [super buttonWithType:buttonType];
    button.frame = frame;
    button.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height * 0.9, frame.size.width, frame.size.height * 0.3)];
    button.subTitleLabel.backgroundColor = [UIColor clearColor];
    button.subTitleLabel.textAlignment = NSTextAlignmentCenter;
    button.subTitleLabel.textColor = [UIColor colorWithRed:0.7452 green:0.7452 blue:0.7452 alpha:1.0];
    button.subTitleLabel.font = [UIFont systemFontOfSize:13];
    [button addSubview:button.subTitleLabel];
    return button;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
