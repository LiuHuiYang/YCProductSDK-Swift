//
//  YCECGDrawLineView.h
//  health
//
//  Created by yc on 2017/6/23.
//  Copyright © 2017年 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 设置每一个格子的宽度 是 1mm  (1pt == 0.16mm)
#define CELL_SIZE (6.25)

/// 每个大图中的格子数
#define CELL_GROUP_COUNT (5) 

/// ECG采样频率
#define ECG_DATA_HZ (250)

/// 波形参考图的位置
typedef NS_ENUM (NSUInteger, YCECGLineReferenceWaveformStyle) {
    
    YCECGLineReferenceWaveformStyleNone = 0, // 不画
    YCECGLineReferenceWaveformStyleTop,   // 画在顶部 ECG测量
    YCECGLineReferenceWaveformStyleMiddle,  // 画中中间 ECG报告
};

@interface YCECGDrawLineView : UIView

/// 采集的频率值 (是250 还是 250中每3个取1)
@property (nonatomic,assign)NSInteger hzValue;

/// 绘制ECG的图形数据
@property (nonatomic,strong) NSMutableArray *datas;
 
/// 不要画网络
@property (nonatomic, assign) BOOL notDrawGrid;

/// 波形参考图
@property (nonatomic, assign) YCECGLineReferenceWaveformStyle drawReferenceWaveformStype;

/// ecg的线条颜色
@property (nonatomic, strong) UIColor *ecgLineColor;

/// 网格颜色
@property (nonatomic, strong) UIColor *gridColor;


/// ECGX方向的偏移量
@property (nonatomic, assign) CGFloat ecgDataOffsetX;

/// ECG参考波形X方向的偏移量
@property (nonatomic, assign) CGFloat referenceWaveformOffsetX;

@end
