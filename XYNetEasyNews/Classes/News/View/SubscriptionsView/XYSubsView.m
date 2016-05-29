//
//  XYSubsView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/16.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYSubsView.h"
#import "XYSubsTool.h"
#import "XYSubscription.h"

@interface XYSubsView ()<UIScrollViewDelegate>
/**
 *  被选中的按钮
 */
@property (nonatomic, weak) UIButton *selectedBtn;
/**
 *  存放所有的频道按钮
 */
@property (nonatomic, strong) NSMutableArray *channelBtns;
@end

@implementation XYSubsView

- (NSMutableArray *)channelBtns{
    if (!_channelBtns) {
        _channelBtns = [NSMutableArray array];
    }
    return _channelBtns;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.backgroundColor = XYSubsBGColor;
        //监听滚动新闻容器，切换选中按钮
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToChangeSubs:) name:XYScrollContainer object:nil];
    }
    return self;
}
//添加子控件
- (void)setSubsChannels:(NSArray *)subsChannels{
    _subsChannels = subsChannels;
    //移除之前添加的按钮
    [self.channelBtns removeAllObjects];
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0 ; i < subsChannels.count; i ++) {
        XYSubscription *subs = subsChannels[i];
        UIButton *btn = [UIButton buttonWithTarget:self selcetor:@selector(subsBtnClick:) controlEvent:UIControlEventTouchUpInside title:subs.title];
        btn.tag = i;
        [self addSubview:btn];
        [self.channelBtns addObject:btn];
        
        if (i == _selectedIndex) {//
            //自身的高
            self.height = btn.height;
        }
        
    }
}
//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger totalCount = self.channelBtns.count;
    
    CGFloat y = 0;
    CGFloat margin = 1;//间隔
    
    for (int i = 0 ; i < totalCount; i ++) {
        UIButton *btn = self.channelBtns[i];
        btn.y = y;
        if (i == 0) {//第一个
            btn.x = 0;
        }else{
            //上一个按钮
            UIButton *lastBtn = self.channelBtns[i - 1];
            btn.x = CGRectGetMaxX(lastBtn.frame) + margin;
        }
        
        if (i == _selectedIndex) {//选中的按钮
            [self subsBtnClick:btn];
        }
    }
    //最后一个按钮
    UIButton *finalBtn = self.channelBtns[totalCount - 1];
    //设置其contentSize
    self.contentSize = CGSizeMake(CGRectGetMaxX(finalBtn.frame) + 50, 0);
}


//响应按钮的点击
- (void)subsBtnClick:(UIButton *)button{
    //取消之前选中的按钮
    self.selectedBtn.selected = NO;
    [self.selectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置当前点击的按钮为选中
    button.selected = YES;
    [button setTitleColor:XYTextColor forState:UIControlStateNormal];
    //动画效果
    [UIView animateWithDuration:0.2 animations:^{
        self.selectedBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
    }];
    
    //发出通知，选中某个频道
    [[NSNotificationCenter defaultCenter] postNotificationName:XYSelectedChannelIndex object:self userInfo:@{XYSelectedChannelIndex: [NSNumber numberWithInteger:button.tag]}];

    self.selectedBtn = button;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y != 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y != 0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    }
}

/**
 *  滚动视图到index位置
 */
- (void)scrollChannelsWithIndex:(int)index{
    //计算选中的按钮的X
    CGFloat selectedX = 0.0;
    for (int j = 0; j < index; j++) {
        UIButton *btn = self.subviews[j];
        selectedX += (btn.width +1);
    }
    //设置滚动
    UIButton *button = self.subviews[index];
    CGFloat limitX = self.contentSize.width - 50 - button.width - XYScreenWidth / 2;
    if (selectedX < XYScreenWidth / 2) {
        //开始，
        self.contentOffset = CGPointZero;
    }else if (selectedX >= limitX){
        //结尾，
        self.contentOffset = CGPointMake(limitX, 0);
    }else{
        self.contentOffset = CGPointMake(selectedX - XYScreenWidth / 2, 0);
    }
//    XYLog(@"%f, %d", selectedX, index);
}

- (void)scrollToChangeSubs:(NSNotification *)noti{
    UIButton *currentBtn = noti.userInfo[XYScrollContainer];
    self.selectedBtn.selected = NO;
    
    currentBtn.selected = YES;
    
    self.selectedBtn = currentBtn;
}
- (void)dealloc{
    XYLog(@"destory");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
