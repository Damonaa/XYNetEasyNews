//
//  XYRelatedView.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/29.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYRelatedView.h"
#import "XYShowPhotoView.h"

@interface XYRelatedView ()
/**
 *  相关图集按钮
 */
@property (nonatomic, weak) UIButton *topBtn;
/**
 *  存放全部的图集
 */
@property (nonatomic, strong) NSMutableArray *showPVS;

@end

@implementation XYRelatedView

- (NSMutableArray *)showPVS{
    if (!_showPVS) {
        _showPVS = [NSMutableArray array];
    }
    return _showPVS;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
    }
    return self;
}
//添加子控件
- (void)setupChildView{
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:topBtn];
    self.topBtn = topBtn;
    [topBtn setImage:[UIImage imageNamed:@"icon_composer_image_select"] forState:UIControlStateNormal];
    [topBtn setTitle:@"相关图集" forState:UIControlStateNormal];
    topBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    topBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [topBtn sizeToFit];
    topBtn.width += 15;
    topBtn.enabled = NO;
    
    //添加四个展示用的imageview
    for (int i = 0; i < 4; i ++) {
        XYShowPhotoView *showPV = [[XYShowPhotoView alloc] init];
        [self addSubview:showPV];
        [self.showPVS addObject:showPV];
    }
    
}
//布局子控件位置 //赋值
- (void)layoutSubviews{
    [super layoutSubviews];
    
    _topBtn.x = 0;
    _topBtn.y = 0;
    CGFloat ivH = 120;
    CGFloat margin = 5;
    
    XYShowPhotoView *showPV1 = self.showPVS[0];
    showPV1.frame = CGRectMake(0, CGRectGetMaxY(_topBtn.frame) + margin, XYScreenWidth, ivH);
    showPV1.album = _albums[0];
    
    XYShowPhotoView *showPV2 = self.showPVS[1];
    showPV2.frame = CGRectMake(0, CGRectGetMaxY(showPV1.frame)+ margin, (XYScreenWidth - margin)/ 2, ivH);
    showPV2.album = _albums[1];
    
    XYShowPhotoView *showPV3 = self.showPVS[2];
    showPV3.frame = CGRectMake(XYScreenWidth / 2, CGRectGetMaxY(showPV1.frame) + margin, (XYScreenWidth - margin) / 2, ivH);
    showPV3.album = _albums[2];
    
    XYShowPhotoView *showPV4 = self.showPVS[3];
    showPV4.frame = CGRectMake(0, CGRectGetMaxY(showPV3.frame) + margin, XYScreenWidth, ivH);
    showPV4.album = _albums[3];
}



@end
