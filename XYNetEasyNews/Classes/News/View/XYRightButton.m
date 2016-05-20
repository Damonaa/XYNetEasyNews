//
//  XYRightButton.m
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import "XYRightButton.h"

@implementation XYRightButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"nav_coins_1"] forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.x = 0;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + 8;
}

@end
