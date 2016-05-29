//
//  XYSubsChannelView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/17.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYSubsChannelView.h"
#import "XYChannelsView.h"
#import "XYSubsTool.h"
#import "XYSubscription.h"
#import "XYSubsButton.h"
#import "UIImage+XY.h"

@interface XYSubsChannelView ()
/**
 *  已订阅频道
 */
@property (nonatomic, weak) XYChannelsView *subsChannelsView;
/**
 *  未订阅频道
 */
@property (nonatomic, weak) XYChannelsView *unsubsChannelsView;
/**
 *  添加频道提示栏
 */
@property (nonatomic, weak) UILabel *remindLable;
/**
 *  替身占位按钮
 */
@property (nonatomic, weak) UIButton *placeHolderBtn;
/**
 *  已订阅频道按钮的坐标
 */
@property (nonatomic, strong) NSMutableArray *subsBtnOriginals;
/**
 *  选中的按钮
 */
@property (nonatomic, weak) XYSubsButton *selectedBtn;
/**
 *  选中按钮的index
 */
@property (nonatomic, assign) NSInteger selectedBtnIndex;

@end

@implementation XYSubsChannelView

- (NSMutableArray *)subsBtnOriginals{
    if (!_subsBtnOriginals) {
        _subsBtnOriginals = [NSMutableArray array];
    }
    return _subsBtnOriginals;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentSize = CGSizeMake(0, 750);
        self.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.856];
        [self setupChildView];
        
        //监听通知
        //添加新的订阅频道
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewChannel:) name:XYAddNewChannel object:nil];
        //点击排序删除按钮
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDelBtnClick:) name:XYSortDelBtnClick object:nil];
        //监听删除按钮的点击
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subsButtonDidClickDel:) name:XYDelChannelBtnClick object:nil];
        //监听隐藏订阅视图按钮的点击
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideChannelView) name:XYHideChannelView object:nil];
        //监听选中顶部的频道按钮
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedChannel:) name:XYSelectedChannelIndex object:nil];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    //顶部工具提示栏
    
    //已订阅频道
    XYChannelsView *subsChannelsView = [[XYChannelsView alloc] init];
    self.subsChannelsView = subsChannelsView;
//    subsChannelsView.backgroundColor = [UIColor orangeColor];
    subsChannelsView.channels = [XYSubsTool subssFromSandBox];
    subsChannelsView.x = 0;
    subsChannelsView.y = 10;
    subsChannelsView.width = XYScreenWidth;

    [self addSubview:subsChannelsView];
    //添加频道提示栏
    UILabel *remindLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subsChannelsView.frame) + 10, XYScreenWidth, 30)];
    self.remindLable = remindLable;
    [self addSubview:remindLable];
    remindLable.text = @"   点击添加更多栏目";
    remindLable.backgroundColor = [UIColor colorWithRed:0.918 green:0.929 blue:0.957 alpha:1.000];
    remindLable.textAlignment = NSTextAlignmentLeft;
    remindLable.font = [UIFont systemFontOfSize:16];
    
    __weak typeof(self) weakSelf = self;
    subsChannelsView.channelsHeight = ^(CGFloat height){
        weakSelf.subsChannelsView.height = height;
        weakSelf.remindLable.y = CGRectGetMaxY(subsChannelsView.frame) + 10;
        weakSelf.unsubsChannelsView.y = CGRectGetMaxY(remindLable.frame) + 10;
    };
    
    //未订阅频道
    XYChannelsView *unsubsChannelsView = [[XYChannelsView alloc] init];
    self.unsubsChannelsView = unsubsChannelsView;
//    unsubsChannelsView.backgroundColor = [UIColor orangeColor];
    unsubsChannelsView.channels = [XYSubsTool unsubssFromSandBox];
    unsubsChannelsView.x = 0;
    unsubsChannelsView.width = XYScreenWidth;

    [self addSubview:unsubsChannelsView];
    
    unsubsChannelsView.channelsHeight = ^(CGFloat height){
        weakSelf.unsubsChannelsView.height = height;
    };
    
}
//布局子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
}
#pragma mark - 响应添加新频道的通知
- (void)addNewChannel:(NSNotification *)noti{
     XYSubscription *subs = noti.userInfo[XYAddNewChannel];
    XYSubsButton *btn = [XYSubsButton buttonWithType:UIButtonTypeCustom];
    btn.subscription = subs;
    
    XYLog(@"%@", btn);
    //计算放在订阅频道上的位置
    //最后一个按钮
    UIButton *lastBtn = [self.subsChannelsView.channelBtns lastObject];
    //将按钮的original转成父视图相应的坐标
    CGPoint deliverOriginal = [noti.userInfo[XYAddNewChannelBtnOriginal] CGPointValue];
    
    CGPoint oldOrginal = CGPointMake(deliverOriginal.x + self.unsubsChannelsView.x, deliverOriginal.y + self.unsubsChannelsView.y);
    //添加当父视图的父视图上
    [self addSubview:btn];
    btn.x = oldOrginal.x;
    btn.y = oldOrginal.y;
    btn.width = XYChannelWidth;
    btn.height = 30;
    
    CGPoint newOrginal;
    CGFloat margin = 10;
    if (lastBtn.x > (self.width * 3 / 4)) {//最后一个按钮在此行的最后一个
        //添加到下一行
        newOrginal = CGPointMake(margin + self.subsChannelsView.x, CGRectGetMaxY(lastBtn.frame) + margin + self.subsChannelsView.y);
        //订阅频道增加一行
        CGFloat increaseRowH = btn.height + margin;
        self.subsChannelsView.height += increaseRowH;
        //提醒以及未订阅视图向下平移
        [UIView animateWithDuration:0.4 animations:^{
            self.remindLable.transform = CGAffineTransformMakeTranslation(0, increaseRowH);
            self.unsubsChannelsView.transform = CGAffineTransformMakeTranslation(0, increaseRowH);
        }];
        
    }else{//添加到此按钮的后面
        newOrginal = CGPointMake(CGRectGetMaxX(lastBtn.frame) + margin + self.subsChannelsView.x, lastBtn.y + self.subsChannelsView.y);
    }
    
    //按钮移动
    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeTranslation(newOrginal.x - oldOrginal.x, newOrginal.y - oldOrginal.y);
    } completion:^(BOOL finished) {
        
        //将按钮添加到已订阅的视图上，同时从总的视图容器中移除
        [btn removeFromSuperview];
        
        XYSubsButton *deliverBtn = [XYSubsButton buttonWithType:UIButtonTypeCustom];
        deliverBtn.subscription = subs;
        deliverBtn.bounds = btn.bounds;
        [self.subsChannelsView addSubview:deliverBtn];
        //添加到内存存储数组中
        [self.subsChannelsView.channelBtns addObject:deliverBtn];
        
        //将相对于self的坐标转换为相对于 self.subsChannelsView的坐标
        deliverBtn.x = newOrginal.x - self.subsChannelsView.x;
        deliverBtn.y = newOrginal.y - self.subsChannelsView.y;
        //刷新已订阅的视图
        [self.subsChannelsView layoutSubviews];
    }];
}

#pragma mark - 排序删除已订阅频道
- (void)sortDelBtnClick:(NSNotification *)noti{
    self.sortDel = !self.sortDel;
    
    BOOL completed = [noti.userInfo[XYSortDelBtnClick] boolValue];

    if (completed) {
        XYLog(@"完成");
        //排序删除频道完成
        [self completedSortDelChannel];
        
    }else{
        XYLog(@"排序");
        //隐藏未订阅频道，提示标签
        self.remindLable.hidden = YES;
        self.unsubsChannelsView.hidden = YES;
        
        //显示已订阅频道按钮上的删除按钮
        for (XYSubsButton *btn in self.subsChannelsView.subviews) {
            for (UIView *delView in btn.subviews) {
                if ([delView isKindOfClass:[UIButton class]]) {
                    delView.hidden = NO;
                }
            }
            
            
            //为按钮添加手势
            [btn addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
//
//            //按下按钮
            [btn addTarget:self action:@selector(scaleBtn:) forControlEvents:UIControlEventTouchDown];
//            //取消按下事件
            [btn addTarget:self action:@selector(cancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
}
//排序删除频道完成
- (void)completedSortDelChannel{
    //显示未订阅频道，提示标签
    self.remindLable.hidden = NO;
    self.unsubsChannelsView.hidden = NO;
    //隐藏已订阅频道按钮上的删除按钮
    for (XYSubsButton *btn in self.subsChannelsView.subviews) {
        for (UIView *delView in btn.subviews) {
            if ([delView isKindOfClass:[UIButton class]]) {
                delView.hidden = YES;
            }
            
            //为按钮添加手势
            [btn removeTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
            //
            //            //按下按钮
            [btn removeTarget:self action:@selector(scaleBtn:) forControlEvents:UIControlEventTouchDown];
            //            //取消按下事件
            [btn removeTarget:self action:@selector(cancelBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
#pragma mark - 拖动按钮事件
//点击
- (void)scaleBtn:(XYSubsButton *)btn{
    
    if (!self.isSortDel) {
        return;
    }
    //将已订阅频道的按钮的全部original添加到数组中
    [self setupOriginals];

    //创建一个按钮的替身
    UIButton *placeHolderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.placeHolderBtn = placeHolderBtn;
    [placeHolderBtn setBackgroundImage:[UIImage imageNamed:@"channel_compact_placeholder_inactive"] forState:UIControlStateNormal];
    placeHolderBtn.size = btn.size;
    placeHolderBtn.x = btn.x;
    placeHolderBtn.y = btn.y;
    
    [self.subsChannelsView addSubview:placeHolderBtn];
    
    //放大按钮
    btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
}
//拖动
- (void)dragMoving:(UIControl *)c withEvent:(UIEvent *)ev
{
    
    if (!self.isSortDel) {
        return;
    }
    XYSubsButton *btn = (XYSubsButton *)c;
    //移动按钮
    btn.center = [[[ev allTouches] anyObject] locationInView:self.subsChannelsView];
    //置顶按钮
    [self.subsChannelsView bringSubviewToFront:btn];
    
    //如果拖动的按钮与其他的按钮有重合
    for (int coincideIndex = 0; coincideIndex < _subsBtnOriginals.count; coincideIndex++ ) {
        //忽略第0个坐标，头条
        if (coincideIndex != 0) {
            NSValue *originalValue = _subsBtnOriginals[coincideIndex];
            CGPoint original = originalValue.CGPointValue;
            CGFloat deltaX = fabs(btn.x - original.x);
            CGFloat deltaY = fabs(btn.y - original.y);
            if (deltaX < 5 && deltaY < 5) {
                //            XYLog(@"将要重合");
                //将此按钮位置添加占位按钮
                self.placeHolderBtn.origin = original;
                NSMutableArray *channelBtns = _subsChannelsView.channelBtns;
                //拖动的按钮的index
                for (int dragIndex = 0; dragIndex < channelBtns.count; dragIndex++) {
                    XYSubsButton *matchBtn = channelBtns[dragIndex];
                    
                    if ([btn isEqual:matchBtn]) {
                        //重新布局拖动后按钮的位置
                        [self relayoutChannelsBtnWithDragIndec:dragIndex coincideIndex:coincideIndex dragButton:btn];
                        break;
                    }
                }
                
                break;
                
            }

        }
    }
}

//松开
- (void)cancelBtnEvent:(XYSubsButton *)btn{
    
    if (!self.isSortDel) {
        return;
    }
    //缩小按钮
    btn.transform = CGAffineTransformIdentity;
    //移除占位按钮
    [self.placeHolderBtn removeFromSuperview];
    //设置选中的按钮
    [self setupSelectedBtn:btn];

}
//设置选中的按钮
- (void)setupSelectedBtn:(XYSubsButton *)btn{
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    //选中按钮的index
    _selectedBtnIndex = 0;
    for (UIButton *btn in _subsChannelsView.channelBtns) {
        if (btn.isSelected) {
            break;
        }
        _selectedBtnIndex ++;
    }
}
//重新布局拖动后按钮的位置
- (void)relayoutChannelsBtnWithDragIndec:(NSInteger)dragIndex coincideIndex:(NSInteger)coincideIndex dragButton:(UIButton *)btn{
    //存放全部的频道按钮
    NSMutableArray *channelBtns = _subsChannelsView.channelBtns;
    //重新排序
    if (dragIndex > coincideIndex) {//如果是向前拖拽重合的按钮（包括） 到 （被拖动的按钮）
        //向后移动，
        for (NSInteger i = coincideIndex; i < dragIndex; i ++) {
            XYSubsButton *moveBtn = channelBtns[i];
            CGPoint newOriginal = [_subsBtnOriginals[i + 1] CGPointValue];
            
            [UIView animateWithDuration:0.5 animations:^{
                moveBtn.origin = newOriginal;
            }];
        }
        //更新存放按钮的数组的顺序
        [channelBtns removeObject:btn];
        [channelBtns insertObject:btn atIndex:coincideIndex - 1];
        
    }else{//向后拖拽 （被拖动的按钮）的后面的按钮到重合的按钮，包括重合的按钮，移动
        //向前移动
        for (NSInteger i = dragIndex + 1; i < coincideIndex + 1; i++) {
            XYSubsButton *moveBtn = channelBtns[i];
            CGPoint newOriginal = [_subsBtnOriginals[i - 1] CGPointValue];
            [UIView animateWithDuration:0.5 animations:^{
                moveBtn.origin = newOriginal;
            }];
        }
        //更新存放按钮的数组的顺序
        [channelBtns removeObject:btn];
        [channelBtns insertObject:btn atIndex:coincideIndex];
    }
}

//将已订阅频道的按钮的全部original添加到数组中
- (void)setupOriginals{
    [self.subsBtnOriginals removeAllObjects];
    [_subsChannelsView.channelBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.subsBtnOriginals addObject:[NSValue valueWithCGPoint:obj.origin]];
    }];
    
}

#pragma mark - 点击删除频道按钮
- (void)subsButtonDidClickDel:(NSNotification *)noti{
    XYSubsButton *subsButton = noti.userInfo[XYDelChannelBtnClick];

    for (UIView *delView in subsButton.subviews) {
        if ([delView isKindOfClass:[UIButton class]]) {
            delView.hidden = YES;
        }
    }
    //将其添加到未订阅频道的界面上
    [self.unsubsChannelsView addSubview:subsButton];
    [self.unsubsChannelsView.channelBtns addObject:subsButton];
}

#pragma mark - 隐藏频道视图 通知
- (void)hideChannelView{
    //保存偏好设置，已订阅的频道
    NSMutableArray *newSortSubss = [NSMutableArray array];
    for (XYSubsButton *btn in _subsChannelsView.channelBtns) {
        XYSubscription *subsc = btn.subscription;
        [newSortSubss addObject:subsc];
    }
    
    [XYSubsTool saveSubs:newSortSubss];
    
    //排序删除频道完成
    [self completedSortDelChannel];
    //刷新滚动频道
    if (_newSubsChannels) {
        _newSubsChannels(newSortSubss);
    }
    
}

#pragma mark - 选中频道按钮
- (void)selectedChannel:(NSNotification *)noti{

    NSInteger index = [noti.userInfo[XYSelectedChannelIndex] integerValue];
//    XYLog(@"%ld", index);
    XYSubsButton *btn = _subsChannelsView.channelBtns[index];
    //设置选中的按钮
    [self setupSelectedBtn:btn];
}
//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
