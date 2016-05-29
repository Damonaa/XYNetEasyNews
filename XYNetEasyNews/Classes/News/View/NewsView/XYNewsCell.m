//
//  XYNewsCell.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/23.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#define XYTitleFont [UIFont systemFontOfSize:17]

#import "XYNewsCell.h"
#import "UIImageView+WebCache.h"
#import "XYNewsItem.h"

@interface XYNewsCell ()

/**
 *  新闻的图片
 */
@property (nonatomic, weak) UIImageView *imgView;
/**
 *  新闻的标题
 */
@property (nonatomic, weak) UILabel *titleLabel;
/**
 *  新闻的接收原因
 */
@property (nonatomic, weak) UILabel *source;
/**
 *  回帖个数
 */
@property (nonatomic, weak) UIButton *replyCount;
/**
 *  新闻类型
 */
//@property (nonatomic, weak) UIImageView *newsType;
/**
 *  底部线
 */
@property (nonatomic, weak) UIView *bottomLine;

@end

@implementation XYNewsCell


+ (instancetype)newsCellWithTableCell:(UITableView *)tableView{
    static NSString *cellID = @"newsCell";
    XYNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[XYNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //新闻图片
        UIImageView *imgView = [[UIImageView alloc] init];
        [self.contentView addSubview:imgView];
        self.imgView = imgView;
        
        //新闻标题
        UILabel *titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        titleLabel.numberOfLines = 2;
        titleLabel.font = XYTitleFont;
        
        //新闻来源
        UILabel *source = [[UILabel alloc] init];
        [self.contentView addSubview:source];
        self.source = source;
        source.font = [UIFont systemFontOfSize:12];
        source.textColor = [UIColor lightGrayColor];
        //跟帖数
        UIButton *replyCount = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:replyCount];
        self.replyCount = replyCount;
        replyCount.titleLabel.font = [UIFont systemFontOfSize:12];
        replyCount.enabled = NO;

        UIView *bottomLine = [[UIView alloc] init];
        [self.contentView addSubview:bottomLine];
        self.bottomLine = bottomLine;
        bottomLine.backgroundColor = [UIColor colorWithWhite:0.817 alpha:0.948];
    }
    return self;
}

//赋值布局
- (void)setNewsItem:(XYNewsItem *)newsItem{
    _newsItem = newsItem;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:newsItem.img] placeholderImage:[UIImage imageNamed:@"contentview_hd_loading_logo"]];
    self.titleLabel.text = newsItem.title;
    //如果有接受原因
    if (![newsItem.recSource isEqualToString:@"#"]) {
        self.source.text = newsItem.recSource;
    
    }
    
    if (self.isTopCell) {//置顶
        _replyCount.backgroundColor = [UIColor colorWithRed:0.290 green:0.522 blue:1.000 alpha:1.000];
        [_replyCount setBackgroundImage:nil forState:UIControlStateNormal];
        [_replyCount setTitle:@"置顶" forState:UIControlStateNormal];
        [_replyCount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _replyCount.layer.cornerRadius = 4;
        _replyCount.layer.masksToBounds = YES;
        
    }else{//其他
        _replyCount.backgroundColor = [UIColor clearColor];
        [_replyCount setBackgroundImage:[UIImage imageNamed:@"contentcell_comment_background"] forState:UIControlStateNormal];
        [_replyCount setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setButton:self.replyCount count:newsItem.replyCount];
        
    }
    [_replyCount sizeToFit];
    
    //布局
    CGFloat margin = 5;
    self.imgView.frame = CGRectMake(margin, margin, 100, 64);
    
    CGFloat titleX = CGRectGetMaxX(_imgView.frame);
    CGFloat titleW = XYScreenWidth - titleX - 20;
    NSString *titleText = newsItem.title;
    CGSize size = [titleText boundingRectWithSize:CGSizeMake(titleW, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:XYTitleFont} context:nil].size;
    self.titleLabel.frame = (CGRect){{titleX + margin, margin},size};
    
    [self.source sizeToFit];
    self.source.y = CGRectGetMaxY(_imgView.frame) - _source.height;
    self.source.x = _titleLabel.x;
    
    //跟帖
    self.replyCount.x = XYScreenWidth - _replyCount.width - margin;
    self.replyCount.y = CGRectGetMaxY(_imgView.frame) - _replyCount.height;
    //底部分割线
    self.bottomLine.frame = CGRectMake(0, XYNewsCellHeight - 0.3, XYScreenWidth, 0.3);
}


//设置按钮标题
- (void)setButton:(UIButton *)btn count:(NSInteger)count{
    if (count == 0) {
        return;
    }
    if (count >= 10000) {
        float i = (float)count / 10000;
        NSString *countStr =[NSString stringWithFormat:@"%.1f万跟帖", i];
        [countStr stringByReplacingOccurrencesOfString:@"0" withString:@""];
        [btn setTitle:countStr forState:UIControlStateNormal];
        
    }else{
        [btn setTitle:[NSString stringWithFormat:@"%ld跟帖", count] forState:UIControlStateNormal];
    }
}

@end
