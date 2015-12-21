//
//  PBChatViewController.m
//  PBEnterBarDemo
//
//  Created by Jpache on 15/12/18.
//  Copyright © 2015年 Jpache. All rights reserved.
//

#import "PBChatViewController.h"
#import "PBEnterBar.h"
#import "PBFaceView.h"
#import "PBMoreView.h"
#import "PBRecordView.h"
#import "PBEmojiManager.h"

@interface PBChatViewController ()<PBEnterBarDelegate, PBMoreViewDelegate, PBRecordViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PBEnterBar *enterBar;
/**
 *  语音键
 */
@property (nonatomic, strong) PBRecordView *recordView;
/**
 *  附加功能扩展页
 */
@property (nonatomic, strong) PBMoreView *moreView;
/**
 *  表情扩展页
 */
@property (nonatomic, strong) PBFaceView *faceView;

@property (nonatomic, strong) UITableView *tableView;
/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation PBChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSourceArray = [NSMutableArray array];
    
    CGFloat enterBarHeight = [PBEnterBar defaultHeight];
//    PBEnterBarType barType = _conversation.conversationType == ConversationTypeChat ? PBEnterbarTypeChat : PBEnterbarTypeGroup;
    self.enterBar = [[PBEnterBar alloc] initWithFrame:CGRectMake(0,
                                                             self.view.frame.size.height - enterBarHeight,
                                                             self.view.frame.size.width,
                                                             enterBarHeight)
                                             type:PBEnterbarTypeChat];
    [_enterBar setDelegate:self];
    //创建更多页面的扩展页
    self.moreView = (PBMoreView *)[_enterBar moreView];
    _moreView.delegate = self;
    //创建表情页面的扩展页
    self.faceView = (PBFaceView *)[_enterBar faceView];
    //创建录音界面的扩展页
    self.recordView = (PBRecordView *)[_enterBar recordView];
    _recordView.delegate = self;
    //调整tabbar与顶部的距离, 也就是保证与superView的底部距离不变
    _enterBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    /***************** TableView *****************/
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 24, self.view.frame.size.width, self.view.frame.size.height - enterBarHeight - 24)
                                                  style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"chatViewCell"];
    [self.view addSubview:_tableView];
    
    //初始化手势
    //给self.view添加手势, 达到点击空白处收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden:)];
    [_tableView addGestureRecognizer:tap];
    
}

#pragma mark - setter

- (void)setEnterBar:(PBEnterBar *)enterBar {
    [_enterBar removeFromSuperview];
    _enterBar = enterBar;
    
    if (_enterBar) {
        [self.view addSubview:_enterBar];
    }
    CGRect rect = self.tableView.frame;
    rect.size.height = self.tableView.frame.size.height - _enterBar.frame.size.height;
    self.tableView.frame = rect;
}

#pragma mark - PBEnterBarDelegate

//改变tableView的frame到toHeight
- (void)enterBarDidChangeFrameToHeight:(CGFloat)toHeight {
    CGRect rect = self.tableView.frame;
    rect.origin.y = 0;
    rect.size.height = self.view.frame.size.height - toHeight;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.tableView.frame = rect;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [self tableViewScrollToBottom:YES];
}

- (void)didStartRecordingVoiceAction:(UIView *)recordView {
    [_recordView recordButtonTouchDown];
    if ([self canRecord]) {
        //如果设备允许访问麦克风
        PBRecordView *tempView = (PBRecordView *)recordView;
        //将提示的框放在屏幕中心
        tempView.center = self.view.center;
        [self.view addSubview:tempView];
        //放在所有视图最前端
        [self.view bringSubviewToFront:recordView];
    }
}

- (void)didCancelRecordingVoiceAction:(UIView *)recordView {
    [_recordView recordButtonTouchUpOutside];
    [_recordView removeFromSuperview];
}

- (void)didFinishRecoingVoiceAction:(UIView *)recordView {
    [_recordView recordButtonTouchUpInside];
    [_recordView removeFromSuperview];
}

- (void)didDragOutsideAction:(UIView *)recordView {
    [_recordView recordButtonDragOutside];
}

- (void)didDragInsideAction:(UIView *)recordView {
    [_recordView recordButtonDragInside];
}

- (void)didSendText:(NSString *)text {
    [_dataSourceArray addObject:[_enterBar.inputTextView.textStorage getPlainString]];
    [_tableView reloadData];
}

#pragma mark - PBRecordViewDelegate

- (void)setRecordingVoiceImage:(UIImageView *)recordAnimationView array:(NSArray *)voiceMessageAnimationImages {
    /*
    [_recorder updateMeters];
    
    recordAnimationView.image = [UIImage imageNamed:[voiceMessageAnimationImages objectAtIndex:0]];
    double voiceSound = 0;
    //获取此时声音的分贝的峰值
    voiceSound = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    int index = voiceSound * [voiceMessageAnimationImages count];
    if (index > [voiceMessageAnimationImages count]) {
        recordAnimationView.image = [UIImage imageNamed:[voiceMessageAnimationImages lastObject]];
    } else {
        recordAnimationView.image = [UIImage imageNamed:[voiceMessageAnimationImages objectAtIndex:index]];
    }
     */
}

#pragma mark - MoreViewDelegate

- (void)moreViewPhotoAction:(PBMoreView *)moreView {
    // 隐藏键盘
    [self.enterBar endEditing:YES];
    /*
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    if (_delegate && [_delegate respondsToSelector:@selector(presentchoosePhoto:)]) {
        [_delegate presentchoosePhoto:self.imagePicker];
    }
    */
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatViewCell" forIndexPath:indexPath];
//    cell.textLabel.text = [_dataSourceArray objectAtIndex:indexPath.row];
    cell.textLabel.attributedText = [PBEmojiManager convertStringWithContainer:cell.textLabel string:[_dataSourceArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - action

//点击空白处收起键盘
- (void)keyBoardHidden:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [_enterBar endEditing:YES];
    }
}

#pragma mark - helper

//是否可用录音功能
- (BOOL)canRecord {
    /*__block BOOL bCanRecord = YES;
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            bCanRecord = YES;
        }else {
            bCanRecord = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Freund需要访问您的麦克风" message:@"请在\"设置-隐私-麦克风\"中启用麦克风" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:alertAction];
                if (_delegate && [_delegate respondsToSelector:@selector(presentRecordAlertViewController:)]) {
                    [_delegate presentRecordAlertViewController:alertController];
                }
            });
        }
    }];
    return bCanRecord;*/
    return YES;
}

//滑动到tableView底部
- (void)tableViewScrollToBottom:(BOOL)animated {
    //如果可滑动范围超出tableView的frame, 则滑动到底部.
    if (_tableView.contentSize.height > _tableView.frame.size.height) {
        CGPoint sizeOff = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [_tableView setContentOffset:sizeOff animated:animated];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
