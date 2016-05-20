//
//  XYSegmentControl.h
//  XYNetEasyNews
//
//  Created by 李小亚 on 16/5/15.
//  Copyright © 2016年 李小亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYSegmentControl;

@protocol XYSegmentControlDelegate <NSObject>

- (void)segmentControl:(XYSegmentControl *)segmentControl didClickBtnAtIndex:(NSInteger)index;

@end

@interface XYSegmentControl : UIView

@property (nonatomic, weak) id<XYSegmentControlDelegate> delegate;

/**
 *  存放设置展示的内容（文字）
 */
@property (nonatomic, strong) NSArray *items;

@end
