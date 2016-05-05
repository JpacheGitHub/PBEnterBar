//
//  PBFacialViewCollectionViewCell.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/21.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBFacialViewCollectionViewCell.h"

@implementation PBFacialViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _faceImage.contentMode = UIViewContentModeScaleAspectFit;
        _faceImage.userInteractionEnabled = YES;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
