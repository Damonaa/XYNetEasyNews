//
//  XYSortDelView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYSortDelView.h"

@interface XYSortDelView ()
/**
 *  切换标签
 */
@property (nonatomic, weak) UILabel *switchLabel;
/**
 *  删除按钮
 */
@property (nonatomic, weak) UIButton *delBtn;
/**
 *  是否完成编辑， 默认NO
 */
@property (nonatomic, assign, getter=isCompleted) BOOL completed;

@end

@implementation XYSortDelView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
        self.backgroundColor = XYSubsBGColor;
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    //切换标签
    UILabel *switchLabel = [[UILabel alloc] init];
    [self addSubview:switchLabel];
    self.switchLabel = switchLabel;
    switchLabel.text = @"  切换栏目";
    switchLabel.font = [UIFont systemFontOfSize:16];
    [switchLabel sizeToFit];
    
    //删除按钮
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"channel_edit_button_bg"] forState:UIControlStateNormal];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"channel_edit_button_selected_bg"] forState:UIControlStateHighlighted];
    [delBtn setTitle:@"排序删除" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    delBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [delBtn sizeToFit];
    [self addSubview:delBtn];
    self.delBtn = delBtn;
    
}
//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.switchLabel.x = 5;
    self.switchLabel.y = (self.height - _switchLabel.height ) / 2;
    
    self.delBtn.x = self.width - _delBtn.width;
    self.delBtn.y = (self.height - _delBtn.height) / 2;
}

//处理按钮的点击事件
- (void)delBtnClcik:(UIButton *)button{
    
    
    if (self.isCompleted) {//完成， 点击结束
        [button setTitle:@"排序删除" forState:UIControlStateNormal];
        self.switchLabel.text = @"  切换栏目";
    }else{//点击排序删除
        [button setTitle:@"完成" forState:UIControlStateNormal];
        self.switchLabel.text = @"  拖动排序";
    }
    
    //发出通知，订阅频道
    [[NSNotificationCenter defaultCenter] postNotificationName:XYSortDelBtnClick object:self userInfo:@{XYSortDelBtnClick: [NSNumber numberWithBool:self.isCompleted]}];
    
    self.completed = !self.completed;
}
@end
