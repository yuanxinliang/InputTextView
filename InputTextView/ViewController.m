//
//  ViewController.m
//  InputTextView
//
//  Created by XL Yuen on 2018/11/27.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import "ViewController.h"
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

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, XLKeyboardFrameChangeDelegate>

@property (nonatomic, weak) UITableView *chatTableView;
@property (nonatomic, weak) XLChatOperationView *bottomView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI {
    
    int bottomViewHeight = 55 + BOTTOMBAR_HEIGHT; // 底部View的高度
    
    UITableView *chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -  bottomViewHeight)];
    chatTableView.backgroundColor = UIColor.redColor;
    chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    chatTableView.delegate = self;
    chatTableView.dataSource = self;
    
    [self.view addSubview:chatTableView];
    self.chatTableView = chatTableView;
    
    XLChatOperationView *bottomView = [[XLChatOperationView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - bottomViewHeight, self.view.frame.size.width, bottomViewHeight)];
    bottomView.delegate = self;
    
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
}

#pragma mark - XLKeyboardFrameChangeDelegate

- (void)keyboardFrameChange:(CGFloat)height{
    
    CGRect frame = self.chatTableView.frame;
    frame.size.height += height;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.chatTableView.frame = frame;
    } completion:^(BOOL finished) {
        if (height < 0) {
            int count = (int)[self.chatTableView numberOfRowsInSection:0];
            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
}

- (void)inputTextViewFrameChange:(CGFloat)height { // 输入框内容高度变化，TableView 也跟着变化
    
    CGRect frame = self.chatTableView.frame;
    frame.size.height -= height;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.chatTableView.frame = frame;
    } completion:^(BOOL finished) {
        int count = (int)[self.chatTableView numberOfRowsInSection:0];
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"信息来了 - %zd", indexPath.row + 1];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}


@end
