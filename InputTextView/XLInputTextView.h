//
//  XLInputTextView.h
//  InputTextView
//
//  Created by XL Yuen on 2018/11/27.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XLInputTextViewFrameChangeDelegate <NSObject>

// 输入框Frame 变化
- (void)inputTextViewFrameChange:(CGFloat)height;

@end


@interface XLInputTextView : UITextView

@property (nonatomic, weak) id<XLInputTextViewFrameChangeDelegate> frameChangeDelegate;


@end

NS_ASSUME_NONNULL_END
