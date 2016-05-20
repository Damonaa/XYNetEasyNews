//
//  XYSubsChannels.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYChannelsView.h"
#import "XYSubsButton.h"
#import "XYSubscription.h"
#import "XYSubsTool.h"
#import "XYSubsChannelView.h"
#import "XYNewsViewController.h"
#import "XYTabBarViewController.h"
#import "XYMainNavController.h"

@interface XYChannelsView ()
/**
 *  已订阅的全部频道
 */
@property (nonatomic, strong) NSMutableArray *subss;
/**
 *  未订阅的全部频道
 */
@property (nonatomic, strong) NSMutableArray *unsubss;

/**
 *  选中的按钮
 */
@property (nonatomic, weak) XYSubsButton *selectedBtn;

@end

@implementation XYChannelsView
#pragma mark - 懒加载
- (NSMutableArray *)subss{
    if (!_subss) {
        _subss = [NSMutableArray array];
    }
    return _subss;
}
- (NSMutableArray *)unsubss{
    if (!_unsubss) {
        _unsubss = [NSMutableArray array];
    }
    return _unsubss;
}
- (NSMutableArray *)channelBtns{
    if (!_channelBtns) {
        _channelBtns = [NSMutableArray array];
    }
    return _channelBtns;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //监听删除按钮的点击
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subsButtonDidClickDel:) name:XYDelChannelBtnClick object:nil];
        //监听点击排序删除按钮
    }
    return self;
}

//添加频道按钮
- (void)setChannels:(NSMutableArray *)channels{
    _channels = channels;
    
    for (int i = 0; i < channels.count; i ++) {
        XYSubscription *subs = _channels[i];
        //添加按钮
        XYSubsButton *subsBtn = [XYSubsButton buttonWithType:UIButtonTypeCustom];
        subsBtn.subscription = subs;
        [subsBtn addTarget:self action:@selector(clickChannelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:subsBtn];
        //添加到数组中
        [self.channelBtns addObject:subsBtn];
        
        if ([subs.title isEqualToString:@"头条"]) {
            //移除背景图
            [subsBtn setBackgroundImage:nil forState:UIControlStateNormal];
            //移除删除按钮
            for (UIView *delView in subsBtn.subviews) {
                if ([delView isKindOfClass:[UIButton class]]) {
                    [delView removeFromSuperview];
                }
            }
        }
    }
}

//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = XYChannelMargin;
    NSInteger totalColumn = XYChannelTotalColumn;
    CGFloat w = XYChannelWidth;
    CGFloat h = 30;
    
    int i = 0;
    for (UIButton *btn in self.channelBtns) {
        
        NSInteger column = i % totalColumn;
        NSInteger row = i / totalColumn;
        
        CGFloat x = margin + (w + margin) * column;
        CGFloat y = margin + (h + margin) * row;
        btn.frame = CGRectMake(x, y, w, h);
        
        if (i == self.channelBtns.count - 1) {
            self.height = CGRectGetMaxY(btn.frame);
            if (_channelsHeight) {
                _channelsHeight(CGRectGetMaxY(btn.frame));
            }
        }
        
        i ++;
    }
    
    
    
}

#pragma mark - 响应按钮的点击事件
- (void)clickChannelBtn:(XYSubsButton *)btn{
//    XYLog(@"%@", btn.currentTitle);
    
    //为频道数组赋值
    [self setupChannelArray];
    
    //父控件
    XYSubsChannelView *subsChannelView = (XYSubsChannelView *)self.superview;
    if (!subsChannelView.isSortDel) {//父控件是非编辑删除状态
        int i = 0;
        for (XYSubscription *subs in _subss) {
            if ([btn.currentTitle isEqualToString:subs.title]) {
                //发出通知，切换频道
                [[NSNotificationCenter defaultCenter] postNotificationName:XYChangeCurrentChannel object:self userInfo:@{XYChangeCurrentChannel: [NSNumber numberWithInt:i]}];
                
                break;
            }
            i ++;
        }
    }
    
    
    
    //添加新的订阅频道
    int j = 0;
    for (XYSubscription *subs in _unsubss) {
        if ([btn.currentTitle isEqualToString:subs.title]) {
            
            //将此按钮移动到已订阅的视图上
            //发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:XYAddNewChannel object:self userInfo:@{XYAddNewChannel: subs, XYAddNewChannelBtnOriginal: [NSValue valueWithCGPoint:btn.origin]}];
            //添加新的订阅
            [btn setBackgroundImage:[UIImage imageNamed:@"channel_compact_placeholder_inactive"] forState:UIControlStateNormal];
            [btn setTitle:nil forState:UIControlStateNormal];

            //重新布局
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //重新排序， 刷新父视图
                [self resetLayoutSubviewsWithSelectedBtn:btn index:j];
                //未订阅频道从内存中移除，添加到订阅频道
                [_unsubss removeObject:subs];
                [_subss addObject:subs];
                //更新保存的偏好设置
                [self updateSaveChannelsWithSubss:_subss unsubss:_unsubss];
            });
            break;
        }
        
        j ++;
    }
}


#pragma mark - 点击删除频道按钮
- (void)subsButtonDidClickDel:(NSNotification *)noti{
    XYSubsButton *subsButton = noti.userInfo[XYDelChannelBtnClick];
    //将此按钮从父视图上移除
//    [subsButton removeFromSuperview];
    //更新用户偏好设置
    //为频道数组赋值
    [self setupChannelArray];
    int i = 0;
    for (XYSubscription *subs in _subss) {
        if ([subsButton.currentTitle isEqualToString:subs.title]) {
            //更新保存的偏好设置
            [self.subss removeObject:subs];
            //添加到未订阅频道
            [self.unsubss addObject:subsButton.subscription];
            [self updateSaveChannelsWithSubss:_subss unsubss:_unsubss];

            //将按钮添加到未订阅频道的界面上, 父视图处理
            //重新排序， 刷新父视图
            [self resetLayoutSubviewsWithSelectedBtn:subsButton index:i];

            break;
        }
        i ++;
    }
    
    
}

#pragma mark - 存取频道
/**
 *  更新保存的偏好设置
 *
 *  @param subss   新的已订阅频道数组
 *  @param unsubss 新的未订阅频道数组
 */
- (void)updateSaveChannelsWithSubss:(NSMutableArray *)subss unsubss:(NSMutableArray *)unsubss{
    [XYSubsTool saveSubs:subss];
    [XYSubsTool saveUnsubs:unsubss];
}
//为频道数组赋值
- (void)setupChannelArray{
    self.subss = nil;
    self.unsubss = nil;
    [self.subss  addObjectsFromArray:[XYSubsTool subssFromSandBox]];
    //未订阅
    [self.unsubss addObjectsFromArray:[XYSubsTool unsubssFromSandBox]];
}

#pragma mark - 重新布局移动按钮的位置
/**
 *  重新布局移动按钮的位置
 *
 *  @param btn 选中的按钮，将要被移除
 *  @param j   选的按钮的index
 */
- (void)resetLayoutSubviewsWithSelectedBtn:(XYSubsButton *)btn index:(int)j{
    //获取点击按钮之后的按钮的frame
    NSMutableArray *frameArray = [NSMutableArray array];
    for (int i = j; i < self.channelBtns.count; i++) {
        XYSubsButton *channelBtn = self.channelBtns[i];
        [frameArray addObject:[NSValue valueWithCGRect:channelBtn.frame]];
//        XYLog(@"gather:%@, index:%d", NSStringFromCGPoint(channelBtn.origin), i);
    }
    //重新布局
    for (int i = j+1; i < self.channelBtns.count; i ++) {
        UIButton *resetBtn = self.channelBtns[i];
        resetBtn.layer.anchorPoint = CGPointMake(0, 0);
        
        //老的frame坐标
        CGPoint oldOrigin = resetBtn.frame.origin;
        //新的frame坐标
        CGPoint newOrigin = [frameArray[i - j - 1] CGRectValue].origin;
        
        //动画
        CABasicAnimation *translationAnim = [CABasicAnimation animationWithKeyPath:@"position"];
        translationAnim.fromValue = [NSValue valueWithCGPoint:oldOrigin];
        translationAnim.toValue = [NSValue valueWithCGPoint:newOrigin];
        translationAnim.duration = 0.6;
        [resetBtn.layer addAnimation:translationAnim forKey:nil];
        resetBtn.origin = newOrigin;

    }
    
    //移除点击的按钮
    [btn removeFromSuperview];
    [self.channelBtns removeObject:btn];
    [self layoutSubviews];
}

//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
