//
//  XYSubsButton.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/16.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYSubscription;

@interface XYSubsButton : UIButton
/**
 *  订阅频道模型
 */
@property (nonatomic, strong) XYSubscription *subscription;

@end
