//
//  XYSegmentControl.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYSegmentControl.h"

@interface XYSegmentControl ()
/**
 *  全部的按钮
 */
@property (nonatomic, strong) NSMutableArray *segmentBtns;
/**
 *  选中的背景图
 */
@property (nonatomic, weak) UIView *bgView;
/**
 *  选中的按钮
 */
@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation XYSegmentControl

#pragma mark - 懒加载
- (NSMutableArray *)segmentBtns{
    if (!_segmentBtns) {
        _segmentBtns = [NSMutableArray array];
    }
    return _segmentBtns;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.height / 2 - 3;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [self setupChildView];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    //添加一个选择时的背景图
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    [self addSubview:bgView];
    
}
//添加按钮
- (void)setItems:(NSArray *)items{
    _items = items;
    
    //有几个item，就添加几个按钮
    for (int i = 0 ; i < _items.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.highlighted = NO;
        
        id item = _items[i];
        if ([item isKindOfClass:[NSString class]]) {//如果是文字
            [btn setTitle:item forState:UIControlStateNormal];
            [btn setTitleColor:XYTextColor forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor clearColor]];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
        }
        
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
        [self.segmentBtns addObject:btn];
    }

    
}
//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = _items.count;
    CGFloat h = self.height;
    CGFloat w = self.width / count;
    
    for (UIButton *btn in _segmentBtns) {
        btn.frame = CGRectMake(btn.tag * w, 0, w, h);
        //设置选中按钮
        if (btn.tag == 0) {
            [self clickBtn:btn];
        }
        
    }
 
}


//点击按钮处理事件
- (void)clickBtn:(UIButton *)button{
    //设置选中按钮
    self.selectedBtn.selected = NO;
    button.selected = YES;
    self.selectedBtn = button;
    
    //设置背景图
    self.bgView.layer.cornerRadius = self.height / 2;
    self.bgView.layer.masksToBounds = YES;
    [UIView animateWithDuration:0.2 delay:0.01 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.frame = button.frame;
    } completion:^(BOOL finished) {
        
    }];
    
    //响应代理
    if ([self.delegate respondsToSelector:@selector(segmentControl:didClickBtnAtIndex:)]) {
        [self.delegate segmentControl:self didClickBtnAtIndex:button.tag];
    }
}
@end
