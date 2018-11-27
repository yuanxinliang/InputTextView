//
//  XLInputTextView.m
//  InputTextView
//
//  Created by XL Yuen on 2018/11/27.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import "XLInputTextView.h"

@interface XLInputTextView ()<UITextViewDelegate>

@end

@implementation XLInputTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.scrollEnabled = NO;
        self.delegate = self;
    }
    return self;
}

-(void)textViewDidChange:(UITextView *)textView{
    static CGFloat maxHeight = 100.0f;
    static CGFloat minHeight = 36.5f;
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    if (size.height <= minHeight) {
        size.height = minHeight;
        textView.scrollEnabled = NO;
    } else if (size.height >= maxHeight) {
        size.height = maxHeight;
        textView.scrollEnabled = YES;
    } else {
        textView.scrollEnabled = NO;
    }
    
    if (size.height != frame.size.height) {
        //        NSLog(@"变化 = %lf", size.height - frame.size.height);
        //        NSLog(@"%lf -- %lf", size.height, frame.size.height);
        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
        if (self.frameChangeDelegate && [self.frameChangeDelegate respondsToSelector:@selector(inputTextViewFrameChange:)]) {
            [self.frameChangeDelegate inputTextViewFrameChange:size.height - frame.size.height];
        }
    }
}

@end
