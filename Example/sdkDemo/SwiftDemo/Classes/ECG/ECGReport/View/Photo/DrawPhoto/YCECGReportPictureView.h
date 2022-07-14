 

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCECGReportPictureView : UIView
 
/// 绘制图片
- (void)drawEcgPoto:(NSArray *)ecgData
           callBack:(void (^)(UIImage *ecgImage))callBack;

@end

NS_ASSUME_NONNULL_END
