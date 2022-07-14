

#import "YCECGReportPictureView.h"
#import "YCECGDrawLineView.h"
@import YCProductSDK;

@interface YCECGReportPictureView ()

@property (weak, nonatomic) YCECGDrawLineView *ecgLineView;

@property (strong, nonatomic) void(^finished)(UIImage *resultImage);


@end

@implementation YCECGReportPictureView

/// 绘制图片
- (void)drawEcgPoto:(NSArray *)ecgData
           callBack:(void (^)(UIImage *ecgImage))callBack {
    
    self.finished = callBack;
    [self setup:ecgData];
}

  
- (void)setup:(NSArray *)dlist{
    
    // FIXME: - 原始数据删除 在这里如果是康源的数据，可能会有问题
    NSMutableArray *ecgDatas =
        [YCECGManager getDrawECGLineData:dlist
                                gridSize:CELL_SIZE
                                   count:20
        ];
    
    // 前3.5秒的时间不要 == 后面有问题再改
    [ecgDatas removeObjectsInRange: NSMakeRange(0, 300)];
    
    // 测试一分钟
    CGFloat totalWidth = CELL_SIZE * 25 * 60;
    
    // 10个小格
    CGFloat height = CELL_SIZE * 20; // CELL_SIZE * 40;
    CGFloat startY = (UIScreen.mainScreen.bounds.size.height - height) * 0.5;
    
    CGRect frame = CGRectMake(0, startY, totalWidth, height);
    YCECGDrawLineView *ecgLineView =
    [[YCECGDrawLineView alloc] initWithFrame:frame];
    ecgLineView.notDrawGrid = YES;
    ecgLineView.hzValue = ECG_DATA_HZ/3;
    
    [self addSubview:ecgLineView];
    self.ecgLineView = ecgLineView;
    
    ecgDatas = [self getShowDataValues:ecgDatas];
    
    ecgLineView.drawReferenceWaveformStype = YCECGLineReferenceWaveformStyleMiddle;
    
    // 每一秒的距离
    CGFloat distanceX = CELL_SIZE * 25;
    ecgLineView.ecgDataOffsetX = distanceX;
    ecgLineView.referenceWaveformOffsetX = CELL_SIZE * 16;
    
    // 计算每一秒的数据量
    // 250HZ, 每次 10秒的数量
    NSInteger everyGroupDataCount = 1.0 * ECG_DATA_HZ / 3 * 10;
    
    // 每一组画10秒数据，两端空白
    CGFloat groupDataWidth = distanceX * (10 + 2);
    
    NSInteger groupCount = ecgDatas.count / everyGroupDataCount;
    NSInteger lastDataCount =
    ecgDatas.count - groupCount * everyGroupDataCount;
    NSInteger startIndex = 0;
    
    NSMutableArray *images = [NSMutableArray array];
    NSArray *subDatas = [NSArray array];
    while (startIndex <= groupCount) {
        
        if (startIndex == groupCount) {
            if (lastDataCount > 0) {
                subDatas =
                [ecgDatas subarrayWithRange:NSMakeRange(groupCount * everyGroupDataCount, lastDataCount)];
            } else {
                break;
            }
            
        } else {
            
            subDatas =
            [ecgDatas subarrayWithRange:NSMakeRange(startIndex * everyGroupDataCount, everyGroupDataCount)];
        }
        
        if (subDatas.count == 0) {
            break;
        }
        
        self.ecgLineView.datas = subDatas.mutableCopy;
        [self.ecgLineView setNeedsDisplay];
        
        UIImage *icon =
        [self clipToImageFromUIView:self.ecgLineView
                             CGRect:CGRectMake(0, 0, groupDataWidth, height)];
        
        if (icon) {
            
//              UIImageWriteToSavedPhotosAlbum(icon, nil, nil, NULL);
            [images addObject:icon];
        }
        
        ++startIndex;
        
        // 只画一次就好
        ecgLineView.drawReferenceWaveformStype = YCECGLineReferenceWaveformStyleNone;
    }
    
    // 拼接
    UIImage *fullImage =
    [self createDataImage:images
                    width:groupDataWidth
             singleHeight:height];
    
    //    UIImageWriteToSavedPhotosAlbum(fullImage, nil, nil, NULL);
    
    [self drawLineView: fullImage
                  size:CGSizeMake(fullImage.size.width + CELL_SIZE, // 为了看到右侧的边沿线
                                  height * (images.count + 1))];
}

// MARK: - 生成图片

/// 获取显示值
- (NSMutableArray *)getShowDataValues:(NSArray *)datas {
    
    // 处理边界值的问题
    CGFloat limitValue = CELL_SIZE * 10;  // CELL_SIZE * 20;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:datas.count];
    
    for (NSNumber *value in datas) {
        
        CGFloat data = value.floatValue;
        
        if (data >= limitValue) {
            data = limitValue;
        }
        
        if (data <= -limitValue) {
            data = -limitValue;
        }
        
        [values addObject:@(data)];
    }
    
    return values;
}

- (void)drawLineView:(UIImage *)reportImage size:(CGSize)size {
    
    YCECGDrawLineView *ecgLineView =
    [[YCECGDrawLineView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [ecgLineView setNeedsDisplay];
    
    // 顶部标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, reportImage.size.width - CELL_SIZE * 25, 44)];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    label.textColor = UIColor.blackColor;
    label.textAlignment = NSTextAlignmentRight;
    label.text =
        NSLocalizedString(@"home_ecg_waveform_description", "");
    [ecgLineView addSubview:label];
    
    
    UIImage *backgroundImage =
    [self screenshotForView:ecgLineView
                       size:ecgLineView.bounds.size];
    
    UIImage *resultImage =
    [self getFinalImage:backgroundImage
            reportImage:reportImage
                offsetY:CELL_SIZE * 10
     ];
    
    // 画底部时间指示条
    resultImage = [self drawBottomTimeRuler:resultImage];
    
    self.finished(resultImage);
}


- (UIImage *)drawBottomTimeRuler:(UIImage *)backgroundImage {
    
    CGSize size = backgroundImage.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    [backgroundImage drawAtPoint:CGPointZero];
    
    
    //获得一个位图图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2);//线的宽度
    CGContextSetStrokeColorWithColor(context,
                                     UIColor.blackColor.CGColor);//画笔线的颜色
    
    //设置起点
    CGFloat marign = CELL_SIZE * 25;
    CGContextMoveToPoint(context, marign, size.height - CELL_SIZE);
    CGContextAddLineToPoint(context, size.width - marign, size.height - CELL_SIZE);
    
    // 一组是10秒 11个刻度 和 11 条竖线
    for (int i = 0; i <= 10; i++) {
        
        CGContextMoveToPoint(context,
                             marign * (i + 1) + 1,
                             size.height - CELL_SIZE * 2);
        
        CGContextAddLineToPoint(context,
                                marign * (i + 1) + 1,
                                size.height);
        
        
        NSString *timeString = [NSString stringWithFormat:@"%ds", i];
        
        [timeString drawAtPoint:CGPointMake(marign * (i + 1) - CELL_SIZE * 1, backgroundImage.size.height - CELL_SIZE * (2 + 5)) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:20], NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    
    CGContextStrokePath(context);
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

/// 合并图
- (UIImage *)createDataImage:(NSMutableArray *)images
                       width:(CGFloat)width
                singleHeight:(CGFloat)singleHeight {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, singleHeight * images.count), NO, 0.0);
    
    for (int i = 0; i < images.count; i++) {
        
        UIImage *icon = images[i];
        
        // 最后一段 不够长，只画固定长度
        if ((i == images.count - 1) &&
            icon.size.width < width ) {
            
            [icon drawInRect:CGRectMake(0, singleHeight * i, icon.size.width, singleHeight)];
            
        } else {
            
            [icon drawInRect:CGRectMake(0, singleHeight * i, width, singleHeight)];
        }
    }
    
    //给ImageView赋值
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return fullImage;
}

- (UIImage *)clipToImageFromUIView:(UIView *)BigView CGRect:(CGRect)rect {
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。
    // 如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    
    UIGraphicsBeginImageContextWithOptions(BigView.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [BigView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*pBigViewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef pCgImageRef = pBigViewImage.CGImage;
    
    CGFloat scale = UIScreen.mainScreen.scale;
    
    CGFloat pRectX = rect.origin.x * scale;
    
    CGFloat pRectY = rect.origin.y * scale;
    
    CGFloat pRectWidth = rect.size.width * scale;
    
    CGFloat pRectHeight = rect.size.height * scale;
    
    CGRect pToRect = CGRectMake(pRectX, pRectY, pRectWidth, pRectHeight);
    
    CGImageRef imageRef =
    CGImageCreateWithImageInRect(pCgImageRef, pToRect);
    
    UIImage *pToImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return pToImage;
    
}

- (UIImage *)getFinalImage:(UIImage *)backgroundImage
               reportImage:(UIImage *)image
                   offsetY:(CGFloat)offsetY {
    
    CGRect frame = CGRectMake(0,
                              0,
                              backgroundImage.size.width,
                              backgroundImage.size.height);
    
    CGRect imageFrame =
    CGRectMake(0, offsetY, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    
    [backgroundImage drawInRect:frame];
    
    [image drawInRect:imageFrame];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}



/// 截图
- (UIImage *)screenshotForView:(UIView *)view size:(CGSize)size {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end
