//
//  XLChatOperationView.h
//  InputTextView
//
//  Created by XL Yuen on 2018/11/27.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLInputTextView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XLKeyboardFrameChangeDelegate <NSObject>

// 键盘Frame 变化
- (void)keyboardFrameChange:(CGFloat)height;

// 输入框Frame 变化
- (void)inputTextViewFrameChange:(CGFloat)height;

@end

@interface XLChatOperationView : UIView

@property (nonatomic, strong) UIButton *faceBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) XLInputTextView *inputTV;
@property (nonatomic, weak) id<XLKeyboardFrameChangeDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
