

#import "YCECGReportBigPictureView.h"

@interface YCECGReportBigPictureView () <UIScrollViewDelegate>

/// 图片
@property (strong, nonatomic) UIImageView *iconView;

/// icon background
@property (strong, nonatomic) UIView *iconBackgroundView;

/// scrollView
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation YCECGReportBigPictureView


- (void)showBigPicture:(UIImage *)ecgPhoto {
    
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    
    _iconBackgroundView = [[UIView alloc] init];
    
    _iconView = [[UIImageView alloc] initWithImage:ecgPhoto];
    
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    _iconView.userInteractionEnabled = YES;
    
    [_iconBackgroundView addSubview:_iconView];
    _iconBackgroundView.bounds = _iconView.bounds;
    _iconBackgroundView.backgroundColor = UIColor.whiteColor;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _scrollView.contentSize = ecgPhoto.size;
    
    
//    [_scrollView addSubview:_iconView];
    [_scrollView addSubview:_iconBackgroundView];
    [self addSubview:_scrollView];
    
    _scrollView.delegate = self;
    _scrollView.maximumZoomScale = 3.0;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.zoomScale = 0.5;
    
    // scoll ceter
    if (_scrollView.contentSize.width > _scrollView.bounds.size.width) {
        [_scrollView setContentOffset:CGPointMake((_scrollView.contentSize.width - _scrollView.bounds.size.width) * 0.5, _scrollView.contentOffset.y) animated:NO];
    }
    
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    
    [self addGestureRecognizer:tap];
     
}


/// iconView scale in center
-(void)scrollViewDidZoom:(UIScrollView *)scrollView {

    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;

    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;

    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;

//    _iconView.center = CGPointMake(xcenter, ycenter);
    _iconBackgroundView.center = CGPointMake(xcenter, ycenter);
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
//    return _iconView;
    return _iconBackgroundView;
}

- (void)hiddenView {
    
    [self removeFromSuperview];
}
 
@end
