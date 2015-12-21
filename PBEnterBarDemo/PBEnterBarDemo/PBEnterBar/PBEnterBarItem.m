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
                      withView:(UIView *)button2View {
    self = [super init];
    if (self) {
        self.button = button;
        self.button2View = button2View;
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
