//
//  PBEnterBarItem.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBEnterBarItem.h"

@implementation PBEnterBarItem

- (instancetype)initWithButton:(UIButton *)button
                    extendView:(UIView *)extendView {
    if (self = [super init]) {
        _button = button;
        _extendView = extendView;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
