//
//  JXDrawView.h
//  JXDrawBoard
//
//  Created by yuezuo on 16/5/5.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXDrawView : UIView

/** 线宽 */
@property (nonatomic,assign) CGFloat lineWidth;
/** 颜色 */
@property (nonatomic,strong) UIColor * lineColor;
/** 图片 */
@property (nonatomic,strong) UIImage * image;
// 撤销
- (void)revokePath;
// 删除
- (void)clear;

@end
