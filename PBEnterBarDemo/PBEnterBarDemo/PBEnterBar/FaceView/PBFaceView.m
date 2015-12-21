//
//  PBFaceView.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBFaceView.h"
#import "PBFacialView.h"

@interface PBFaceView ()<PBFacialViewDelegate>

@property (nonatomic, strong) PBFacialView *facialView;

@end

@implementation PBFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self =  [super initWithFrame:frame]) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    self.facialView = [[PBFacialView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _facialView.delegate = self;
    [self addSubview:_facialView];
}

#pragma mark - PBFacialViewDelegate

- (void)selectedFacialView:(NSString *)emojiTitle faceImage:(UIImage *)image isDelete:(BOOL)isDelete {
    if (_delegate && [_delegate respondsToSelector:@selector(selectedFacialView:faceImage:isDelete:)]) {
        [_delegate selectedFacialView:emojiTitle faceImage:image isDelete:isDelete];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
