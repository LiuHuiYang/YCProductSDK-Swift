//
//  YCECGDrawLineView.m
//  health
//
//  Created by yc on 2017/6/23.
//  Copyright © 2017年 yc. All rights reserved.
//

#import "YCECGDrawLineView.h"



@implementation YCECGDrawLineView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = YES;
        self.datas = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect{
    
    if (self.notDrawGrid == NO) {
        
        if (self.gridColor == nil) {
            
            [self drawECGbackgroundGrid:[self colorWithHex:0xF0F0F0
                                                         alpha:1.0]
                             groupColor:[self colorWithHex:0xD9D9D9 alpha:1.0]
                          bigGroupColor: [self colorWithHex:0x8C8C8C alpha:1.0]
             
             
             
             ];
        } else {
            
            [self drawECGbackgroundGrid:self.gridColor
                             groupColor:self.gridColor
                          bigGroupColor:self.gridColor
             
             
             
             ];
        }
        
        
    }
    
    if (self.drawReferenceWaveformStype != YCECGLineReferenceWaveformStyleNone) {
        
        [self drawReferenceWaveform:rect
                          lineWidth:1
                          lineColor:[self colorWithHex:0xFB3159 alpha:1.0]
         ];
    }
    
    UIColor *ecgLineColor =
        (self.ecgLineColor == nil) ?
        [self colorWithHex:0xFB3159 alpha:1.0] :
        self.ecgLineColor;
    
    [self drawECGDataGrid: rect
                lineWidth: 1.25
                lineColor: ecgLineColor
     ];
}


/// 画ECG数据
- (void)drawECGDataGrid:(CGRect)rect
              lineWidth:(CGFloat)lineWidth
              lineColor:(UIColor *)lineColor {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, lineWidth);//线的宽度
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);//画笔线的颜色
    
    // ECG采样频率为 250HZ == 0.004s 每3个取一个的时间变成 0.004 X 3 = 0.012s
    // 标准走纸速度 25mm/s 对应的距离应该是 25 * 0.012s = 0.3mm (0.3小格)
    // 25 * (1.0 / 250 * 3)
    
    CGFloat width = CELL_SIZE * 0.3; //25 * (1.0 / 250 * 3) * CELL_SIZE;
    
    for (int i = 0; i < [self.datas count]; i++) {
        
        if (i > 0) {
            
            // * 2 是为了使波形更加明显示 （即使用 双倍标准化）
            CGFloat pos1 = [self.datas[i-1] floatValue];
            CGFloat pos2 = [self.datas[i] floatValue];
            
            CGContextMoveToPoint(context,
                                 (i - 1) * width + self.ecgDataOffsetX,
                                 rect.size.height * 0.5 - pos1);
            
            CGContextAddLineToPoint(context,
                                    i * width + self.ecgDataOffsetX,
                                    rect.size.height * 0.5 - pos2);
            
        }
    }
    
    CGContextStrokePath(context);
}

/// 画标准化参考图
- (void)drawReferenceWaveform:(CGRect)rect
                    lineWidth:(CGFloat)lineWidth
                    lineColor:(UIColor *)lineColor {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, lineWidth);//线的宽度
    
    CGContextSetStrokeColorWithColor(context,
                                     lineColor.CGColor);//画笔线的颜色
    
    // Y轴的比例高度 正常标准化
    CGFloat baseHeight = 10 * CELL_SIZE; // 20 * CELL_SIZE; // 双倍标准化
    
    // 一个大格的距离
    CGFloat bigGrid = 5 * CELL_SIZE;
    CGFloat marignX = 2 * CELL_SIZE;
    
    CGFloat startX = 0 + self.referenceWaveformOffsetX;
    CGFloat startY = 0;
    
    if (self.drawReferenceWaveformStype == YCECGLineReferenceWaveformStyleNone) {
    
        startY = -bigGrid;
    
    } else if (self.drawReferenceWaveformStype == YCECGLineReferenceWaveformStyleTop) {
        
        startY = baseHeight + bigGrid; // 原来的
    
    } else if (self.drawReferenceWaveformStype == YCECGLineReferenceWaveformStyleMiddle) {
        
        startY = rect.size.height * 0.5;
    }
    
    CGContextMoveToPoint(context, startX, startY);
    
    startX += marignX;
    CGContextAddLineToPoint(context, startX, startY);
    
    startY -= baseHeight;
    CGContextAddLineToPoint(context, startX, startY);
    
    startX += bigGrid;
    CGContextAddLineToPoint(context, startX, startY);
    
    startY += baseHeight;
    CGContextAddLineToPoint(context, startX, startY);
    
    startX += marignX;
    CGContextAddLineToPoint(context, startX, startY);
    
}

/// 绘制ECG的背景格子
- (void)drawECGbackgroundGrid:(UIColor *)lineColor
                   groupColor:(UIColor *)groupColor
                bigGroupColor:(UIColor *)bigGroupColor {
    
    /// 格子次数
    NSInteger gridCount = 0;
    
    // 设置每一个格子的宽度 是 1mm  1pt == 0.16mm
    CGFloat cellSize = CELL_SIZE; // pt
    
    // 获取上下文 知道你要画图的地方 (就是画布)
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    
    // 网上的举例是先画大格再画小格，其实没有必要，直接按格画，每五格为一
    // 效果是相同的，同时也少了循环的代码
    
    // 横向
    gridCount = 0;
    CGFloat startY = 1;
    while (startY < height) {
        
        if (gridCount % CELL_GROUP_COUNT == 0) {
            
            CGContextSetLineWidth(context, 1);
            CGContextSetStrokeColorWithColor(context,
                                             [groupColor CGColor]);
            
        } else {
            
            CGContextSetLineWidth(context, 0.5);
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        }
        
        ++gridCount;
        CGContextMoveToPoint(context, 1, startY);
        CGContextAddLineToPoint(context, width, startY);
        startY += cellSize;
        CGContextStrokePath(context);
    }
    
    // 纵向
    gridCount = 0;
    CGFloat startX = 1;
    while (startX < width) {
        
        if (gridCount % (CELL_GROUP_COUNT * CELL_GROUP_COUNT) == 0) {
            
            CGContextSetLineWidth(context, 3);
            CGContextSetStrokeColorWithColor(context,
                                             [bigGroupColor CGColor]);
            
        } else if (gridCount % CELL_GROUP_COUNT == 0) {
            
            CGContextSetLineWidth(context, 1);
            CGContextSetStrokeColorWithColor(context,
                                             [groupColor CGColor]);
            
        } else {
            
            CGContextSetLineWidth(context, 0.5);
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
        }
        
        ++gridCount;
        CGContextMoveToPoint(context, startX, 1);
        CGContextAddLineToPoint(context, startX, height);
        startX += cellSize;
        CGContextStrokePath(context);
    }
    
}


- (UIColor *)colorWithHex:(u_int32_t)colorHex alpha:(CGFloat)alpha {
    
    //  255 255 255 ==  #0x ff ff ff
    // 获得各种颜色
    NSUInteger red = (colorHex & 0xFF0000) >> 16;
    NSUInteger green = (colorHex & 0x00FF00) >> 8;
    NSUInteger blue = colorHex & 0x0000FF;
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
