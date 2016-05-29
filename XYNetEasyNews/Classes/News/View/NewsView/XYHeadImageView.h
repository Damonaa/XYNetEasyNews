//
//  XYHeadImageView.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/23.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYAdItem;




@interface XYHeadImageView : UIImageView



@property (nonatomic, strong) XYAdItem *adItem;

/**
 *  是否是第一个视图
 */
@property (nonatomic, assign, getter=isFirstIV) BOOL firstIV;

@end
