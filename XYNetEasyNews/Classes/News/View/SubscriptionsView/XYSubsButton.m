//
//  XYSubsButton.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/16.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYSubsButton.h"
#import "XYSubscription.h"

@interface XYSubsButton ()
/**
 *  标图片
 */
@property (nonatomic, weak) UIImageView *tagView;

@end

@implementation XYSubsButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundImage:[UIImage imageNamed:@"channel_grid_circle"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"channel_grid_circle"] forState:UIControlStateHighlighted];
        //左上角添加删除按钮，默认隐藏
        UIButton *delBtn = [UIButton buttonWithNormalImage:[UIImage imageNamed:@"channel_edit_delete"] highlightedImage:nil target:self selcetor:@selector(delBtnClick) controlEvent:UIControlEventTouchUpInside];
//        self.delBtn = delBtn;
        [self addSubview:delBtn];
        delBtn.frame = CGRectMake(0, 0, 16, 16);
        delBtn.hidden = YES;
    }
    return self;
}


- (void)setSubscription:(XYSubscription *)subscription{
    _subscription = subscription;
    
    [self setTitle:subscription.title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    //设置字体
    if (subscription.title.length > 2 && subscription.title.length < 5) {
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }else if(subscription.title.length > 4){
        self.titleLabel.font = [UIFont systemFontOfSize:10];
    }else{
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    
    //添加标签
    if (subscription.isNewSubs || subscription.isHotSubs) {
        UIImageView *tagView = [[UIImageView alloc] init];
        self.tagView = tagView;
        tagView.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString *imageName = subscription.isHotSubs ? @"subscription_topic_hot" : @"subscription_topic_new";
        tagView.image = [UIImage imageNamed:imageName];
        [self addSubview:tagView];
    }
    
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.tagView.width = 22;
    self.tagView.height = 11;
    self.tagView.x = self.width - self.tagView.width;
    self.tagView.y = 0;
    
}

//删除按钮的点击
- (void)delBtnClick{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XYDelChannelBtnClick object:self userInfo:@{XYDelChannelBtnClick: self}];
}
@end
