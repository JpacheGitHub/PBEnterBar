# PBEnterBar
一个聊天界面底部enterBar的demo。
分为几部分：
- 输入框：可输入文字，系统表情，自定义表情。
- 语音按钮：输入语音消息。
- 表情按钮：选择自定义表情。
- 附加功能：如发送图片，定位信息等（只是做了个样子，没有实现功能）

## 初始化方法

两种初始化方法：

```bash
- (instancetype)initWithFrame:(CGRect)frame
                         type:(PBEnterBarType)type;
```
```bash
- (instancetype)initWithFrame:(CGRect)frame
            horizontalPadding:(CGFloat)horizontalPadding
              verticalPadding:(CGFloat)verticalPadding
           inputViewMinHeight:(CGFloat)inputViewMinHeight
           inputViewMaxHeight:(CGFloat)inputViewMaxHeight
                         type:(PBEnterBarType)type;
```

## Delegate

1. PBEnterBarDelegate
2. PBMoreViewDelegate
3. PBRecordViewDelegate

具体的代理方法在对应的.h中有对应的解释。

- PBEnterbarTypeChat
- PBEnterbarTypeGroup

这两种类型需要签以下两个代理

- PBMoreViewDelegate
- PBRecordViewDelegate

若为 ```bash PBEnterbarTypeComment ``` 类型，则不需要签后两个代理。

## 添加组件

### PBEnterbarTypeChat，PBEnterbarTypeGroup

```bash
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
```

### PBEnterbarTypeComment
```bash
//创建表情页面的扩展页
self.faceView = (PBFaceView *)[_enterBar faceView];
//调整tabbar与顶部的距离, 也就是保证与superView的底部距离不变
_enterBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
```
