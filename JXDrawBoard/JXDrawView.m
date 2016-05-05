//
//  JXDrawView.m
//  JXDrawBoard
//
//  Created by yuezuo on 16/5/5.
//  Copyright © 2016年 yuezuo. All rights reserved.
//

#import "JXDrawView.h"

#import "DrawPath.h"

@interface JXDrawView ()

/** 当前点位置 */
@property (nonatomic,assign) CGPoint curP;
/** 曲线 */
@property (nonatomic,strong) DrawPath * path;
/** 保存绘制曲线 */
@property (nonatomic,strong) NSMutableArray * pathArray;

@end

@implementation JXDrawView

- (void)awakeFromNib {
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


// 初始化
- (void)setup {
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    self.lineWidth = 1;
    self.lineColor = [UIColor blackColor];
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
    // 取出当前位置
    self.curP = [gesture locationInView:self];
    
    // 当开始拖拽的时候
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 创建路径
        _path = [[DrawPath alloc] init];
        
        [self.path moveToPoint:self.curP];
        
        // 设置线宽
        _path.lineWidth = self.lineWidth;
        
        // 设置颜色
        _path.pathColor = self.lineColor;
        
        // 在创建之后就加入数组，当重绘的时候数组中就会有东西了
        [self.pathArray addObject:self.path];
    }
    
    // 添加路径
    [self.path addLineToPoint:self.curP];
    // 重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    if (self.pathArray.count == 0) return;
    for (DrawPath * path in self.pathArray) {
        if ([path isKindOfClass:[UIImage class]]) { // 为图片的时候
            
            UIImage * image = (UIImage *)path;
            [image drawInRect:rect];
            
        } else { // 为线的时候
            [path.pathColor set];
            [path stroke];
        }
    }
}

#pragma mark - 懒加载


- (NSMutableArray *)pathArray {
    if (_pathArray == nil) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
    
}

#pragma mark - 画板操作
- (void)revokePath {
    [self.pathArray removeLastObject];
    [self setNeedsDisplay];
}
- (void)clear {
    [self.pathArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self.pathArray addObject:image];
    [self setNeedsDisplay];
}
@end
