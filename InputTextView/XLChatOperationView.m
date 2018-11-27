//
//  XLChatOperationView.m
//  InputTextView
//
//  Created by XL Yuen on 2018/11/27.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import "XLChatOperationView.h"

/*** 屏幕的宽高 ***/
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height

#define IS_IPHONE_X_LATER   (SCREEN_HEIGHT == 812 || SCREEN_HEIGHT == 896)
//齐刘海和底部触摸条
#define STATUSBAR_HEIGHT         (IS_IPHONE_X_LATER ? 44 : 20)   //状态栏高度
#define NAVIGATIONBAR_HEIGHT     44                              //导航栏高度
#define TABBAR_HEIGHT            49                              //标签栏高度
#define BOTTOMBAR_HEIGHT         (IS_IPHONE_X_LATER ? 34 : 0)    //底部触摸条高度

@interface XLChatOperationView ()<XLInputTextViewFrameChangeDelegate>

@end

@implementation XLChatOperationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        
        CGFloat width = self.frame.size.width;
        
        UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
        topLine.backgroundColor = [UIColor colorWithWhite:0.75 alpha:1.0];
        [self addSubview:topLine];
        
        // 创建表情按钮
        _faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        [_faceBtn setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [self addSubview:_faceBtn];
        
        // 创建输入框
        _inputTV = [[XLInputTextView alloc] initWithFrame:CGRectMake(55, 9, width - 55 * 2, 36.5f)];
        _inputTV.layer.cornerRadius = 5;
        _inputTV.layer.borderWidth = 0.5f;
        _inputTV.layer.borderColor = [[UIColor colorWithWhite:0.75 alpha:1.0] CGColor];
        _inputTV.font = [UIFont systemFontOfSize:17.0f];
        _inputTV.frameChangeDelegate = self;
        [self addSubview:_inputTV];
        
        // 创建更多按钮
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 45, 10, 35, 35)];
        [_moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        [self addSubview:_moreBtn];
        
        // 监听键盘Frame 改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)willChange:(NSNotification *)noti {
    
    CGRect keyboardFrameBegin = [noti.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardFrameEnd = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (keyboardFrameBegin.origin.y == keyboardFrameEnd.origin.y) return; // 这种情况是TableView 使用UIScrollViewKeyboardDismissModeOnDrag时，避免重复调用
    
    CGFloat height = 0;
    if (keyboardFrameBegin.origin.y == SCREEN_HEIGHT) { // 键盘从底部弹出
        height = keyboardFrameEnd.origin.y - keyboardFrameBegin.origin.y + BOTTOMBAR_HEIGHT;
    } else if (keyboardFrameEnd.origin.y == SCREEN_HEIGHT) { // 键盘隐藏到底部
        height = keyboardFrameEnd.origin.y - keyboardFrameBegin.origin.y - BOTTOMBAR_HEIGHT;
    } else { // 键盘高度发生变化
        height = keyboardFrameEnd.origin.y - keyboardFrameBegin.origin.y;
    }
    
    CGRect frame = self.frame;
    frame.origin.y += height;
    self.frame = frame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardFrameChange:)]) {
        [self.delegate keyboardFrameChange:height];
    }
}

#pragma mark - XLInputTextViewFrameChangeDelegate

- (void)inputTextViewFrameChange:(CGFloat)height {
    
    // 输入框高度变化之后，调整此View的内部控件Frame
    [self adjustOtherViewFrame:height];
    
    // 输入框高度变化之后，调整外部控件Frame
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputTextViewFrameChange:)]) { // 这里代理通知外部控件调整Frame
        [self.delegate inputTextViewFrameChange:height];
    }
}

- (void)adjustOtherViewFrame:(CGFloat)height {
    
    CGRect frame = self.frame;
    frame.origin.y -= height;
    frame.size.height += height;
    self.frame = frame;
    
    CGRect inputViewFrame = self.inputTV.frame;
    CGFloat inputViewMaxY = CGRectGetMaxY(inputViewFrame);
    
    CGRect faceBtnFrame = self.faceBtn.frame;
    faceBtnFrame.origin.y = inputViewMaxY - faceBtnFrame.size.height;
    self.faceBtn.frame = faceBtnFrame;
    
    CGRect moreBtnFrame = self.moreBtn.frame;
    moreBtnFrame.origin.y = inputViewMaxY - moreBtnFrame.size.height;
    self.moreBtn.frame = moreBtnFrame;
    
}

@end
