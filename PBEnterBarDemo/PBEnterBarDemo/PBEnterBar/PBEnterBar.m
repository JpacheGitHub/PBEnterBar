//
//  PBEnterBar.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBEnterBar.h"
#import "PBFaceView.h"
#import "PBRecordView.h"
#import "PBEnterBarItem.h"
#import "PBEmojiManager.h"

@interface PBEnterBar ()<UITextViewDelegate, PBFaceViewDelegate>

@property (nonatomic, assign) CGFloat version;

@property (nonatomic, strong) NSMutableArray *leftItems;
@property (nonatomic, strong) NSMutableArray *rightItems;

/**
 *  转变输入样式
 */
@property (nonatomic, strong) UIButton *styleChangeButton;
/**
 *  表情数组
 */
@property (nonatomic, strong) NSArray *defaultEmoji;
/**
 *  是否显示底部扩展页
 */
@property (nonatomic, assign, getter=isShowButtomView) BOOL showButtomView;
/**
 *  当前活跃的底部扩展页
 */
@property (nonatomic, strong) UIView *activityButtomView;
/**
 *  输入框
 */
@property (nonatomic, assign) CGFloat previousTextViewContentHeight;//上一次inputTextView的contentSize.height
@property (nonatomic, strong) NSLayoutConstraint *inputViewWidthItemsLeftConstraint;
@property (nonatomic, strong) NSLayoutConstraint *inputViewWidthoutItemsLeftConstraint;
@end


@implementation PBEnterBar

@synthesize faceView = _faceView;
@synthesize moreView = _moreView;
@synthesize recordView = _recordView;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:self];
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame horizontalPadding:5 verticalPadding:5 inputViewMinHeight:36 inputViewMaxHeight:90 type:PBEnterbarTypeGroup];
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                         type:(PBEnterBarType)type {
    
    self = [self initWithFrame:frame horizontalPadding:5 verticalPadding:5 inputViewMinHeight:36 inputViewMaxHeight:90 type:type];
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                         type:(PBEnterBarType)type {
    
    if (frame.size.height < (verticalPadding * 2 + inputViewMinHeight)) {
        frame.size.height = verticalPadding * 2 + inputViewMinHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        _horizontalPadding = horizontalPadding;
        _verticalPadding = verticalPadding;
        _inputViewMinHeight = inputViewMinHeight;
        _inputViewMaxHeight = inputViewMaxHeight;
        _enterBarType = type;
        
        self.leftItems = [NSMutableArray array];
        self.rightItems = [NSMutableArray array];
        _version = [[[UIDevice currentDevice] systemVersion] floatValue];
        self.activityButtomView = nil;
        _showButtomView = NO;
        
//        self.backgroundColor = [UIColor whiteColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        _recordImageName = @"ToolViewInputVoice";
        _recordHLImageName = @"ToolViewInputVoiceHL";
        _faceImageName = @"ToolViewEmotion";
        _faceHLImageName = @"ToolViewEmotionHL";
        _moreImageName = @"TypeSelectorBtn_Black";
        _moreHLImageName = @"TypeSelectorBtnHL_Black";
        _defaultImageName = @"ToolViewKeyboard";
        _defaultHLImageName = @"ToolViewKeyboardHL";
        
        [self createSubView];
    }
    return self;
}

#pragma mark - createSubView

- (void)createSubView {
    //toolbar
    self.enterBarView = [[UIView alloc] initWithFrame:self.bounds];
    _enterBarView.backgroundColor = [UIColor colorWithRed:0.9672 green:0.9672 blue:0.9672 alpha:1.0];
    [self addSubview:_enterBarView];
    
    //inputTextView
    self.inputTextView = [[PBEnterBarTextView alloc] initWithFrame:CGRectMake(_horizontalPadding,
                                                                           _verticalPadding,
                                                                           self.frame.size.width - _horizontalPadding * 2,
                                                                           self.frame.size.height - _verticalPadding * 2)];
    
    _inputTextView.delegate = self;
    _inputTextView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _inputTextView.layer.masksToBounds = YES;
    _inputTextView.layer.borderWidth = 0.65f;
    _inputTextView.layer.cornerRadius = 6.0f;
    
    _previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
    [self willShowInputTextViewToHeight:_previousTextViewContentHeight];
    [_enterBarView addSubview:_inputTextView];
    
    switch (_enterBarType) {
        case PBEnterbarTypeChat: {
            [self createRecordFunction];
            PBEnterBarItem *faceItem = [self createFaceFunction];
            PBEnterBarItem *moreItem = [self createMoreFunction];
            [self setInputViewRightItems:@[faceItem, moreItem]];
            [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[styleChangeButton]-padding-[inputTextView]-padding-[faceItem]-padding-[moreItem]-padding-|" options:0 metrics:@{@"padding":@(_horizontalPadding)} views:@{@"styleChangeButton":_styleChangeButton, @"inputTextView":_inputTextView, @"faceItem":faceItem.button, @"moreItem":moreItem.button}]];
        }
            break;
        case PBEnterbarTypeGroup: {
            [self createRecordFunction];
            PBEnterBarItem *faceItem = [self createFaceFunction];
            PBEnterBarItem *moreItem = [self createMoreFunction];
            [self setInputViewRightItems:@[faceItem, moreItem]];
            [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[styleChangeButton]-padding-[inputTextView]-padding-[faceItem]-padding-[moreItem]-padding-|" options:0 metrics:@{@"padding":@(_horizontalPadding)} views:@{@"styleChangeButton":_styleChangeButton, @"inputTextView":_inputTextView, @"faceItem":faceItem.button, @"moreItem":moreItem.button}]];
        }
            break;
        case PBEnterbarTypeComment: {
            PBEnterBarItem *faceItem = [self createFaceFunction];
            [self setInputViewRightItems:@[faceItem]];
            [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[inputTextView]-padding-[faceItem]-padding-|" options:0 metrics:@{@"padding":@(_horizontalPadding)} views:@{@"inputTextView":_inputTextView, @"faceItem":faceItem.button}]];
        }
            break;
        default:
            break;
    }
}

- (void)createRecordFunction {
    //转变输入样式按钮
    _styleChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _styleChangeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_styleChangeButton setImage:[UIImage imageNamed:_recordImageName] forState:UIControlStateNormal];
    [_styleChangeButton setImage:[UIImage imageNamed:_recordHLImageName] forState:UIControlStateHighlighted];
    [_styleChangeButton addTarget:self action:@selector(styleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    PBEnterBarItem *styleItem = [[PBEnterBarItem alloc] initWithButton:_styleChangeButton
                                                              withView:nil];
    [self setInputViewLeftItems:@[styleItem]];
    
    //录制
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.frame = _inputTextView.frame;
    _recordButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_recordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[[UIImage imageNamed:@"record_btn_back"]
                                       stretchableImageWithLeftCapWidth:10
                                       topCapHeight:10]
                             forState:UIControlStateNormal];
    
    [_recordButton setBackgroundImage:[[UIImage imageNamed:@"record_btn_back_selected"]
                                       stretchableImageWithLeftCapWidth:10
                                       topCapHeight:10]
                             forState:UIControlStateHighlighted];
    
    [_recordButton setTitle:NSLocalizedString(@"按住  录音", nil) forState:UIControlStateNormal];
    [_recordButton setTitle:NSLocalizedString(@"松开  结束", nil) forState:UIControlStateHighlighted];
    _recordButton.hidden = YES;
    [_recordButton addTarget:self action:@selector(recordButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(recordButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [_recordButton addTarget:self action:@selector(recordButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(recordDragOutside:) forControlEvents:UIControlEventTouchDragExit];
    [_recordButton addTarget:self action:@selector(recordDragInside:) forControlEvents:UIControlEventTouchDragEnter];
    [_enterBarView addSubview:_recordButton];
}

- (PBEnterBarItem *)createFaceFunction {
    //表情
    self.faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_faceButton setImage:[UIImage imageNamed:_faceImageName] forState:UIControlStateNormal];
    [_faceButton setImage:[UIImage imageNamed:_faceHLImageName] forState:UIControlStateHighlighted];
    [_faceButton addTarget:self action:@selector(faceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    PBEnterBarItem *faceItem = [[PBEnterBarItem alloc] initWithButton:self.faceButton
                                                             withView:self.faceView];
    return faceItem;
}

- (PBEnterBarItem *)createMoreFunction {
    //更多
    self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_moreButton setImage:[UIImage imageNamed:_moreImageName]
                 forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:_moreHLImageName] forState:UIControlStateHighlighted];
    [_moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    PBEnterBarItem *moreItem = [[PBEnterBarItem alloc] initWithButton:self.moreButton
                                                             withView:self.moreView];
    return moreItem;
}

#pragma mark - getter

- (UIView *)faceView {
    if (_faceView == nil) {
        _faceView = [[PBFaceView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_enterBarView.frame), self.frame.size.width, 180)];
        ((PBFaceView *)_faceView).delegate = self;
        _faceView.backgroundColor = [UIColor colorWithRed:0.9672 green:0.9672 blue:0.9672 alpha:1.0];
        _faceView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _faceView;
}

- (UIView *)moreView {
    if (_moreView == nil) {
        _moreView = [[PBMoreView alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(_enterBarView.frame),
                                                               self.frame.size.width,
                                                               80)
                                               type:_enterBarType];
        _moreView.backgroundColor = [UIColor colorWithRed:0.9672 green:0.9672 blue:0.9672 alpha:1.0];
        _moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _moreView;
}

- (UIView *)recordView {
    if (_recordView == nil) {
        _recordView = [[PBRecordView alloc] initWithFrame:CGRectMake(90, 130, 140, 140)];
    }
    return _recordView;
}

#pragma mark - setter

- (void)setRecordView:(UIView *)recordView {
    _recordView = recordView;
}

- (void)setMoreView:(UIView *)moreView {
    _moreView = moreView;
    //每次重新给moreView赋值, 则重新将moreView赋值给对应的enterBarItem
    for (PBEnterBarItem *item in _rightItems) {
        if (item.button == _moreButton) {
            item.button2View = _moreView;
            break;
        }
    }
}

- (void)setFaceView:(UIView *)faceView {
    _faceView = faceView;
    //每次重新给faceView赋值, 则重新将faceView赋值给对应的enterBarItem
    for (PBEnterBarItem *item in _rightItems) {
        if (item.button == _faceButton) {
            item.button2View = _faceView;
            break;
        }
    }
}

- (void)setInputViewLeftItems:(NSArray *)inputViewLeftItems {
    for (PBEnterBarItem *item in _leftItems) {
        [item.button removeFromSuperview];
        [item.button2View removeFromSuperview];
    }
    [self.leftItems removeAllObjects];
    
    CGFloat oX = _horizontalPadding;
    CGFloat itemHeight = _enterBarView.frame.size.height - _verticalPadding * 2;
    for (id item in inputViewLeftItems) {
        if ([item isKindOfClass:[PBEnterBarItem class]]) {
            PBEnterBarItem *enterItem = (PBEnterBarItem *)item;
            if (enterItem.button) {
                CGRect itemFrame = enterItem.button.frame;
                if (itemFrame.size.height == 0) {
                    itemFrame.size.height = itemHeight;
                }
                
                if (itemFrame.size.width == 0) {
                    itemFrame.size.width = itemFrame.size.height;
                }
                
                itemFrame.origin.x = oX;
                itemFrame.origin.y = (_enterBarView.frame.size.height - itemFrame.size.height) / 2;
                enterItem.button.frame = itemFrame;
                oX += (itemFrame.size.width + _horizontalPadding);
                
                [_enterBarView addSubview:enterItem.button];
                [_leftItems addObject:enterItem];
            }
        }
    }
    
    CGRect inputFrame = _inputTextView.frame;
    CGFloat value = inputFrame.origin.x - oX;
    inputFrame.origin.x = oX;
    inputFrame.size.width += value;
    _inputTextView.frame = inputFrame;
    
    CGRect recordFrame = _recordButton.frame;
    recordFrame.origin.x = inputFrame.origin.x;
    recordFrame.size.width = inputFrame.size.width;
    _recordButton.frame = recordFrame;
}

- (void)setInputViewRightItems:(NSArray *)inputViewRightItems {
    for (PBEnterBarItem *item in _rightItems) {
        [item.button removeFromSuperview];
        [item.button2View removeFromSuperview];
    }
    [self.rightItems removeAllObjects];
    
    CGFloat oMaxX = _enterBarView.frame.size.width - _horizontalPadding;
    CGFloat itemHeight = _enterBarView.frame.size.height - _verticalPadding * 2;
    if ([inputViewRightItems count] > 0) {
        for (NSInteger i = (inputViewRightItems.count - 1); i >= 0; i--) {
            id item = [inputViewRightItems objectAtIndex:i];
            if ([item isKindOfClass:[PBEnterBarItem class]]) {
                PBEnterBarItem *enterItem = (PBEnterBarItem *)item;
                if (enterItem.button) {
                    CGRect itemFrame = enterItem.button.frame;
                    if (itemFrame.size.height == 0) {
                        itemFrame.size.height = itemHeight;
                    }
                    
                    if (itemFrame.size.width == 0) {
                        itemFrame.size.width = itemFrame.size.height;
                    }
                    
                    oMaxX -= itemFrame.size.width;
                    itemFrame.origin.x = oMaxX;
                    itemFrame.origin.y = (_enterBarView.frame.size.height - itemFrame.size.height) / 2;
                    enterItem.button.frame = itemFrame;
                    oMaxX -= _horizontalPadding;
                    
                    [_enterBarView addSubview:enterItem.button];
                    [_rightItems addObject:item];
                }
            }
        }
    }
    
    CGRect inputFrame = _inputTextView.frame;
    CGFloat value = oMaxX - CGRectGetMaxX(inputFrame);
    inputFrame.size.width += value;
    _inputTextView.frame = inputFrame;
    
    CGRect recordFrame = _recordButton.frame;
    recordFrame.origin.x = inputFrame.origin.x;
    recordFrame.size.width = inputFrame.size.width;
    _recordButton.frame = recordFrame;
}

- (void)setFaceImageName:(NSString *)faceImageName {
    _faceImageName = faceImageName;
    [_faceButton setImage:[UIImage imageNamed:faceImageName] forState:UIControlStateNormal];
}

- (void)setFaceHLImageName:(NSString *)faceHLImageName {
    _faceHLImageName = faceHLImageName;
    [_faceButton setImage:[UIImage imageNamed:faceHLImageName] forState:UIControlStateHighlighted];
}

- (void)setRecordImageName:(NSString *)recordImageName {
    _recordImageName = recordImageName;
    [_styleChangeButton setImage:[UIImage imageNamed:recordImageName] forState:UIControlStateNormal];
}

- (void)setRecordHLImageName:(NSString *)recordHLImageName {
    _recordHLImageName = recordHLImageName;
    [_styleChangeButton setImage:[UIImage imageNamed:recordHLImageName] forState:UIControlStateNormal];
}

- (void)setDefaultImageName:(NSString *)defaultImageName {
    _defaultImageName = defaultImageName;
}

- (void)setDefaultHLImageName:(NSString *)defaultHLImageName {
    _defaultHLImageName = defaultHLImageName;
}

- (void)setMoreImageName:(NSString *)moreImageName {
    _moreImageName = moreImageName;
    [_moreButton setImage:[UIImage imageNamed:moreImageName] forState:UIControlStateNormal];
}

- (void)setMoreHLImageName:(NSString *)moreHLImageName {
    _moreHLImageName = moreHLImageName;
    [_moreButton setImage:[UIImage imageNamed:moreHLImageName] forState:UIControlStateHighlighted];
}

#pragma mark - extend view action

//录音, 键盘切换
- (void)styleButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:_defaultImageName] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:_defaultHLImageName] forState:UIControlStateHighlighted];
        for (PBEnterBarItem *item in self.rightItems) {
            item.button.selected = NO;
        }
        
        [_moreButton setImage:[UIImage imageNamed:_moreImageName]
                     forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:_moreHLImageName] forState:UIControlStateHighlighted];
        
        [_faceButton setImage:[UIImage imageNamed:_faceImageName]
                     forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:_faceHLImageName] forState:UIControlStateHighlighted];
        
        for (PBEnterBarItem *item in self.leftItems) {
            if (item.button != sender) {
                item.button.selected = NO;
            }
        }
        
        //录音状态下，不显示底部扩展页面
        [self willShowBottomView:nil];
        
        //以使enterBarView回到最小高度
        [self willShowInputTextViewToHeight:_inputViewMinHeight];
        [_inputTextView resignFirstResponder];
    }else {
        [sender setImage:[UIImage imageNamed:_recordImageName] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:_defaultHLImageName] forState:UIControlStateHighlighted];
        //键盘也算一种底部扩展页面
        [_inputTextView becomeFirstResponder];
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _recordButton.hidden = !sender.isSelected;
        _inputTextView.hidden = sender.isSelected;
    } completion:nil];
}

//表情页, 键盘切换(与录音点击事件逻辑基本一致)
- (void)faceButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    PBEnterBarItem *faceItem = nil;
    for (PBEnterBarItem *item in _rightItems) {
        if (item.button == sender){
            faceItem = item;
            continue;
        }
        
        item.button.selected = NO;
    }
    
    [_moreButton setImage:[UIImage imageNamed:_moreImageName]
                 forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:_moreHLImageName]
                 forState:UIControlStateHighlighted];
    
    for (PBEnterBarItem *item in _leftItems) {
        item.button.selected = NO;
        [item.button setImage:[UIImage imageNamed:_recordImageName]
                     forState:UIControlStateNormal];
        [item.button setImage:[UIImage imageNamed:_defaultHLImageName]
                     forState:UIControlStateHighlighted];
    }
    
    if (sender.selected) {
        [_faceButton setImage:[UIImage imageNamed:_defaultImageName] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:_defaultHLImageName] forState:UIControlStateHighlighted];
        //如果处于文字输入状态，使文字输入框失去焦点
        [_inputTextView resignFirstResponder];
        
        [self willShowBottomView:faceItem.button2View];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _recordButton.hidden = sender.selected;
            _inputTextView.hidden = !sender.selected;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        [_faceButton setImage:[UIImage imageNamed:_faceImageName] forState:UIControlStateNormal];
        [_faceButton setImage:[UIImage imageNamed:_faceHLImageName] forState:UIControlStateHighlighted];
        [self.inputTextView becomeFirstResponder];
    }
}

//附加功能页, 键盘切换(与录音点击事件逻辑基本一致)
- (void)moreButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    PBEnterBarItem *moreItem = nil;
    for (PBEnterBarItem *item in _rightItems) {
        if (item.button == sender){
            moreItem = item;
            continue;
        }
        
        item.button.selected = NO;
    }
    
    [_faceButton setImage:[UIImage imageNamed:_faceImageName]
                 forState:UIControlStateNormal];
    [_faceButton setImage:[UIImage imageNamed:_faceHLImageName] forState:UIControlStateHighlighted];
    
    for (PBEnterBarItem *item in _leftItems) {
        item.button.selected = NO;
        [item.button setImage:[UIImage imageNamed:_recordImageName]
                     forState:UIControlStateNormal];
        [item.button setImage:[UIImage imageNamed:_defaultHLImageName] forState:UIControlStateHighlighted];
    }
    
    if (sender.selected) {
        [_moreButton setImage:[UIImage imageNamed:_defaultImageName]
                forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:_defaultHLImageName] forState:UIControlStateHighlighted];
        //如果处于文字输入状态，使文字输入框失去焦点
        [_inputTextView resignFirstResponder];
        
        [self willShowBottomView:moreItem.button2View];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _recordButton.hidden = sender.selected;
            _inputTextView.hidden = !sender.selected;
        } completion:nil];
    }else {
        [_moreButton setImage:[UIImage imageNamed:_moreImageName]
                forState:UIControlStateNormal];
        [_moreButton setImage:[UIImage imageNamed:_moreHLImageName] forState:UIControlStateHighlighted];
        [self.inputTextView becomeFirstResponder];
    }
}

#pragma mark - record button action

- (void)recordButtonTouchDown:(UIButton *)sender {
    [(PBRecordView *)self.recordView recordButtonTouchDown];
    if (_delegate && [_delegate respondsToSelector:@selector(didStartRecordingVoiceAction:)]) {
        [_delegate didStartRecordingVoiceAction:self.recordView];
    }
}

- (void)recordButtonTouchUpOutside:(UIButton *)sender {
    
    [(PBRecordView *)self.recordView recordButtonTouchUpOutside];
    
    if (_delegate && [_delegate respondsToSelector:@selector(didCancelRecordingVoiceAction:)]) {
        
        [_delegate didCancelRecordingVoiceAction:_recordView];
    }
    [(PBRecordView *)self.recordView removeFromSuperview];
}

- (void)recordButtonTouchUpInside:(UIButton *)sender {
    
    [(PBRecordView *)self.recordView recordButtonTouchUpInside];
    [(PBRecordView *)self.recordView removeFromSuperview];
    
    if ([_delegate respondsToSelector:@selector(didFinishRecoingVoiceAction:)]) {
        
        [_delegate didFinishRecoingVoiceAction:_recordView];
    }
    
}

- (void)recordDragOutside:(UIButton *)sender {
    
    [(PBRecordView *)self.recordView recordButtonDragOutside];
    if ([_delegate respondsToSelector:@selector(didDragOutsideAction:)]) {
        
        [_delegate didDragOutsideAction:_recordView];
    }
}

- (void)recordDragInside:(UIButton *)sender {
    
    [(PBRecordView *)self.recordView recordButtonDragInside];
    if ([_delegate respondsToSelector:@selector(didDragInsideAction:)]) {
        
        [_delegate didDragInsideAction:_recordView];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [_delegate inputTextViewWillBeginEditing:_inputTextView];
    }
    
    for (PBEnterBarItem *item in _leftItems) {
        item.button.selected = NO;
        [item.button setImage:[UIImage imageNamed:_recordImageName]
                     forState:UIControlStateNormal];
        [item.button setImage:[UIImage imageNamed:_recordHLImageName] forState:UIControlStateHighlighted];
    }
    
    for (PBEnterBarItem *item in _rightItems) {
        item.button.selected = NO;
    }
    
    [_faceButton setImage:[UIImage imageNamed:_faceImageName] forState:UIControlStateNormal];
    [_faceButton setImage:[UIImage imageNamed:_faceHLImageName] forState:UIControlStateHighlighted];
    [_moreButton setImage:[UIImage imageNamed:_moreImageName]
                 forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:_moreHLImageName] forState:UIControlStateHighlighted];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    
    if ([_delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [_delegate inputTextViewDidBeginEditing:_inputTextView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

//因为textView没有return点击事件, 所以用这个方法代替点击事件, text为最后输入的字符, 判断如果是return键打出的\n, 则发送.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([_delegate respondsToSelector:@selector(didSendText:)]) {
            [_delegate didSendText:textView.text];
            _inputTextView.text = @"";
            [self willShowInputTextViewToHeight:[self getTextViewContentH:_inputTextView]];
        }
        return NO;
    }else {
        if ([text hasPrefix:@"["] && [text hasSuffix:@"]"]) {
            if ([[PBEmojiManager shareManager].emojiDic objectForKey:text]) {
                [self selectedFacialView:text faceImage:[UIImage imageNamed:[[PBEmojiManager shareManager].emojiDic objectForKey:text]] isDelete:NO];
                return NO;
            }
        }
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}

#pragma mark - FaceViewDelegate

- (void)selectedFacialView:(NSString *)str faceImage:(UIImage *)image isDelete:(BOOL)isDelete {
    
    // 记录光标位置, location 对应光标的位置
    CGFloat location = _inputTextView.selectedRange.location;
    
    NSString *enterText = _inputTextView.text;

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:_inputTextView.attributedText];

    if (!isDelete && str.length > 0) {
        
        PBEmojiTextAttchment *emojiTextAttachment = [PBEmojiTextAttchment new];
        
        emojiTextAttachment.emojiTitle = str;
        //设置表情图片
        emojiTextAttachment.image = image;
        
        //解决表情比文字高一些
        CGFloat height = 0;
        if ([_inputTextView.text isEqualToString:@""]) {
            height = [UIFont systemFontOfSize:16].lineHeight;
        }else {
            height = _inputTextView.font.lineHeight;
        }
        
        emojiTextAttachment.bounds = CGRectMake(0, -5, height + 1, height + 1);
        
        [attr insertAttributedString:[NSAttributedString attributedStringWithAttachment:emojiTextAttachment] atIndex:location];
        
        // 设置整个属性字符串中的文本属性
        NSRange allRange = NSMakeRange(0, attr.length);
        // 让可变的属性文本的字体 和 textView 的保持一致，不做此操作添加表情后，在输入文字会变得比原来的字小一号。
        [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:allRange];
        
        //如果不改变光标位置直接赋值，插入一个表情后光标会移动到最后
        _inputTextView.text = @"";
        _inputTextView.attributedText = attr;
        
        // 重新设置光标位置
        _inputTextView.selectedRange = NSMakeRange(location + 1, 0);
    }else {
        if (enterText.length > 0) {
            NSInteger length = 1;
            if (enterText.length >= 2) {
                NSString *subStr = [enterText substringFromIndex:enterText.length - 2];
                if ([_defaultEmoji containsObject:subStr]) {
                    length = 2;
                }
            }
            _inputTextView.attributedText = [self backspaceText:attr length:length];
        }
    }
    [self textViewDidChange:_inputTextView];
//    NSLog(@"%@", [_inputTextView.textStorage getPlainString]);
}

- (NSMutableAttributedString*)backspaceText:(NSMutableAttributedString*) attr length:(NSInteger)length {
    NSRange range = [_inputTextView selectedRange];
    if (range.location == 0) {
        return attr;
    }
    [attr deleteCharactersInRange:NSMakeRange(range.location - length, length)];
    return attr;
}

- (void)sendFaceButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSendText:)]) {
        [_delegate didSendText:_inputTextView.text];
        _inputTextView.text = @"";
        [self willShowInputTextViewToHeight:[self getTextViewContentH:_inputTextView]];
    }
}

#pragma mark - private input view

//返回文本框内容的高度
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if (self.version >= 7.0) {
        //向上进一取整, 返回最佳适应大小, 默认返回视图大小
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

//改变tabBar和enterBar位置信息
- (void)willShowInputTextViewToHeight:(CGFloat)toHeight {
    
    if (toHeight < _inputViewMinHeight) {
        toHeight = _inputViewMinHeight;
    }
    if (toHeight > _inputViewMaxHeight) {
        toHeight = _inputViewMaxHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight) {
        return;
    }else {
        
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        
        CGRect rect2 = _enterBarView.frame;
        rect2.size.height += changeHeight;
        
        __weak __typeof(&*self)weakSelf = self;
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakSelf.frame = rect;
                             weakSelf.enterBarView.frame = rect2;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
        if (_version < 7.0) {
            [_inputTextView setContentOffset:CGPointMake(0.0f, (_inputTextView.contentSize.height - _inputTextView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight;
        
        if (_delegate && [_delegate respondsToSelector:@selector(enterBarDidChangeFrameToHeight:)]) {
            [_delegate enterBarDidChangeFrameToHeight:self.frame.size.height];
        }
    }
}

#pragma mark - UIKeyboardNotification

//输入框上移
- (void)enterKeyboardWillChangeFrame:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    //弹出键盘动画结束后, 键盘的位置
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //弹出键盘动画前, 键盘的位置
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //键盘弹出的动画时间, 使动画更连贯
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //获取键盘弹出的动画类型
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    //网上说要左移16位, 为什么呢?---左移是因为键盘弹出的动画和这个动画的枚举类型不同, 左移后效果才一样
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState)
                     animations:animations
                     completion:nil];
}

#pragma mark - private bottom view

- (void)willShowBottomHeight:(CGFloat)bottomHeight {
    CGRect fromFrame = self.frame;
    //显示的扩展页的高度(原本的enterBar的高度计算在内)
    CGFloat toHeight = _enterBarView.frame.size.height + bottomHeight;
    //生成显示的扩展页的位置信息
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    //如果需要将所有扩展页面都隐藏，而此时已经隐藏了所有扩展页面，则不进行任何操作
    if(bottomHeight == 0 && self.frame.size.height == _enterBarView.frame.size.height) {
        return;
    }
    //如果扩展页的高度为0, 则不显示扩展页
    if (bottomHeight == 0) {
        _showButtomView = NO;
    }
    else{
        //否则显示
        _showButtomView = YES;
    }
    //更新tabBar的位置信息
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = toFrame;
                     }
                     completion:nil];
    
    //改变高度到toHeight
    if (_delegate && [_delegate respondsToSelector:@selector(enterBarDidChangeFrameToHeight:)]) {
        [_delegate enterBarDidChangeFrameToHeight:toHeight];
    }
}

- (void)willShowBottomView:(UIView *)bottomView {
    
    if (![_activityButtomView isEqual:bottomView]) {
        
        CGRect rect = bottomView.frame;
        rect.origin.y = CGRectGetMaxY(_enterBarView.frame);
        bottomView.frame = rect;
        [self addSubview:bottomView];
        //如果当前显示的扩展页和即将显示的扩展页不是同一扩展页
        //三目运算符, 判断是否有扩展页需要显示, 有则返回扩展页高度, 没有则返回0;
        CGFloat bottomHeight = bottomView ? bottomView.frame.size.height : 0;
        [self willShowBottomHeight:bottomHeight];
        //如果有扩展页需要显示
        if (bottomView) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGRect rect = bottomView.frame;
                rect.origin.y = CGRectGetMaxY(_enterBarView.frame);
                bottomView.frame = rect;
            } completion:nil];
        }
        
        if (_activityButtomView) {
            [_activityButtomView removeFromSuperview];
        }
        self.activityButtomView = bottomView;
    }
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame {
    
    if (beginFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        //如果开始显示当前扩展页之前, 并未显示扩展页
        //一定要把self.activityButtomView置为空
        [self willShowBottomHeight:toFrame.size.height];
        if (_activityButtomView) {
            [_activityButtomView removeFromSuperview];
        }
        self.activityButtomView = nil;
        
    }else if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
        //如果当前需要显示的扩展页显示后高度为0, 则不需要显示扩展页;
        [self willShowBottomHeight:0];
    }else {
        //如果开始显示当前扩展页之前, 已经有其他扩展页进行显示;
        [self willShowBottomHeight:toFrame.size.height];
    }
}

#pragma mark - public

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight {
    return 5 * 2 + 36;
}

//停止编辑
- (BOOL)endEditing:(BOOL)force {
    BOOL result = [super endEditing:force];
    
    for (PBEnterBarItem *item in self.leftItems) {
        item.button.selected = NO;
    }
    
    for (PBEnterBarItem *item in _rightItems) {
        item.button.selected = NO;
        if (item.button != _faceButton && item.button != _moreButton) {
            [item.button setImage:[UIImage imageNamed:_recordImageName]
                         forState:UIControlStateNormal];
            [item.button setImage:[UIImage imageNamed:_recordHLImageName] forState:UIControlStateHighlighted];
        }
    }
    [_moreButton setImage:[UIImage imageNamed:_moreImageName]
                 forState:UIControlStateNormal];
    [_moreButton setImage:[UIImage imageNamed:_moreHLImageName] forState:UIControlStateHighlighted];
    
    [_faceButton setImage:[UIImage imageNamed:_faceImageName]
                 forState:UIControlStateNormal];
    [_faceButton setImage:[UIImage imageNamed:_faceHLImageName] forState:UIControlStateHighlighted];
    
    [self willShowBottomView:nil];
    
    return result;
}

//取消录音
- (void)cancelTouchRecord {
    if ([_recordView isKindOfClass:[PBRecordView class]]) {
        [(PBRecordView *)_recordView recordButtonTouchUpInside];
        [_recordView removeFromSuperview];
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
