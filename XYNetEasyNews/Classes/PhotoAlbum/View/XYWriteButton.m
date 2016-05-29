//
//  XYWriteButton.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/25.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYWriteButton.h"

@implementation XYWriteButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"toolbar_light_comment"] forState:UIControlStateNormal];
        [self setTitle:@"写跟帖" forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [self sizeToFit];
        
        self.layer.cornerRadius = self.width / 2 - 23;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.25;

    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.x = 5;
    self.imageView.y = 0;
    [self.imageView sizeToFit];
    self.titleLabel.x = CGRectGetMaxX(self.imageView.frame);
}
@end
