//
//  JLScrollView.m
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//

//屏幕宽
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define JLKeyWindow [UIApplication sharedApplication].keyWindow

#define bigScrollVIewTag 101

#import "JLPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "JLPieProgressView.h"
#import "KxMovieViewController.h"



@interface JLPhotoBrowser()<UIScrollViewDelegate>{
    int flag;
    KxMovieViewController *kxVC;

    
}
/**
 *  底层滑动的scrollview
 */
@property (nonatomic,weak) UIScrollView *bigScrollView;
/**
 *  黑色背景view
 */
@property (nonatomic,weak) UIView *blackView;
/**
 *  原始frame数组
 */
@property (nonatomic,strong) NSMutableArray *originRects;
@end

@implementation JLPhotoBrowser

-(NSMutableArray *)originRects{
    
    if (_originRects==nil) {
        
        _originRects = [NSMutableArray array];
        
    }
    
    return _originRects;
    
}

+ (instancetype)photoBrowser{
    
    return [[self alloc] init];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //0.创建黑色背景view
        [self setupBlackView];
        
        //1.创建bigScrollView
        [self setupBigScrollView];
        
        
        
        [self setupButton];
        
        
    }
    return self;
}


- (void)setupButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"看看" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//    btn.backgroundColor = [UIColor cyanColor];
    btn.frame = CGRectMake(10, 10, 50, 40);
    [self addSubview:btn];
    
    
}

- (void)buttonClick{
    [self playVideohehe];

     
}

- (void)playVideohehe{
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"041114-579" ofType:@"mp4"];
    //NSString *path = [[NSBundle mainBundle]pathForResource:@"o0131g70phxm701" ofType:@"mp4"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    
    
    if ([path.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    
    // disable buffering
    //parameters[KxMovieParameterMinBufferedDuration] = @(0.0f);
    //parameters[KxMovieParameterMaxBufferedDuration] = @(0.0f);
    
    if(kxVC){
        
        kxVC.view.alpha = 1;
        
        
    }else{
        kxVC = [KxMovieViewController movieViewControllerWithContentPath:path  parameters:parameters];
       // [self addChildViewController:kxVC];
        
        
        
        float arch = M_PI_2;
        kxVC.view.transform = CGAffineTransformMakeRotation(arch);
        
        
                   // CGFloat ScreenWidth   = [UIScreen mainScreen].bounds.size.width;
                   // CGFloat ScreenHeight = [UIScreen mainScreen].bounds.size.height;
        
        // self.view.bounds = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
        kxVC.view.bounds = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
        
        [self addSubview:kxVC.view];
        
    }
    
}





#pragma mark 创建黑色背景

-(void)setupBlackView{
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    [self addSubview:blackView];
    self.blackView = blackView;
    
}

#pragma mark 创建背景bigScrollView

-(void)setupBigScrollView{
    
    UIScrollView *bigScrollView = [[UIScrollView alloc] init];
    bigScrollView.backgroundColor = [UIColor clearColor];
    bigScrollView.delegate = self;
    bigScrollView.tag = bigScrollVIewTag;
    bigScrollView.pagingEnabled = YES;
    bigScrollView.bounces = YES;
    bigScrollView.showsHorizontalScrollIndicator = NO;
    CGFloat scrollViewX = 0;
    CGFloat scrollViewY = 0;
    CGFloat scrollViewW = ScreenWidth;
    CGFloat scrollViewH = ScreenHeight;
    bigScrollView.frame = CGRectMake(scrollViewX, scrollViewY, scrollViewW, scrollViewH);
    [self addSubview:bigScrollView];
    self.bigScrollView = bigScrollView;
    
}

-(void)show{
    
    //1.添加photoBrowser
    [JLKeyWindow addSubview:self];
    
    //2.获取原始frame
    [self setupOriginRects];
    
    //3.设置滚动距离
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth*self.photos.count, 0);
    self.bigScrollView.contentOffset = CGPointMake(ScreenWidth*self.currentIndex, 0);
    //4.创建子视图
    [self setupSmallScrollViews];
    
}



#pragma mark 创建子视图

-(void)setupSmallScrollViews{
    
    //__weak JLPhotoBrowser *weakSelf = self;
    
    for (int i=0; i<self.photos.count; i++) {
        
        UIScrollView *smallScrollView = [self creatSmallScrollView:i];
        JLPhoto *photo = [self addTapWithTag:i];
        [smallScrollView addSubview:photo];
        
      //  JLPieProgressView *loop = [self creatLoopWithTag:i];
        //[smallScrollView addSubview:loop];
        
     //   NSURL *bigImgUrl = [NSURL URLWithString:photo.bigImgUrl];
        
        //检查图片是否已经缓存过
//        [[SDImageCache sharedImageCache] queryDiskCacheForKey:photo.bigImgUrl done:^(UIImage *image, SDImageCacheType cacheType) {
//            
//            if (image==nil) {
//                loop.hidden = NO;
//            }
//            
//        }];
        
        
        
      //  UIImageView *imageView = self.photos[i];
        
       // if (imageView.image != nil) {
            
           // loop.hidden = YES;
            
         //   photo.image = imageView.image;

             [self setupPhotoFrame:photo];
            
            
            
            
            
            
            
        
        
        
        /*
        [photo sd_setImageWithURL:bigImgUrl placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            //设置进度条
            loop.progressValue = (CGFloat)receivedSize/(CGFloat)expectedSize;
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image!=nil) {
                
                loop.hidden = YES;
                
                //下载回来的图片
                if (cacheType==SDImageCacheTypeNone) {
                    
                    [weakSelf setupPhotoFrame:photo];
                    
                }else{
                    
                    photo.frame = [weakSelf.originRects[i] CGRectValue];
                    [UIView animateWithDuration:0.3 animations:^{
                        [weakSelf setupPhotoFrame:photo];
                    }];
                    
                }
                
            }else{
                
                //图片下载失败
                photo.bounds = CGRectMake(0, 0, 240, 240);
                photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
                photo.contentMode = UIViewContentModeScaleAspectFit;
                photo.image = [UIImage imageNamed:@"preview_image_failure"];
                
                [loop removeFromSuperview];
                
            }
            
        }];
         */
        
    //}
    }
    
}

- (void)setupPhotoFrame:(JLPhoto *)photo{
    
    UIScrollView *smallScrollView = (UIScrollView *)photo.superview;
    
    self.blackView.alpha = 1.0;
    
    CGFloat ratio = (double)photo.image.size.height/(double)photo.image.size.width;
    
    CGFloat bigW = ScreenWidth;
    CGFloat bigH = ScreenWidth*ratio;
    
    if (bigH<ScreenHeight) {
        photo.bounds = CGRectMake(0, 0, bigW, bigH);
        photo.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    }else{//设置长图的frame
        photo.frame = CGRectMake(0, 0, bigW, bigH);
        smallScrollView.contentSize = CGSizeMake(ScreenWidth, bigH);
    }
    
}

- (UIScrollView *)creatSmallScrollView:(int)tag{
    
    UIScrollView *smallScrollView = [[UIScrollView alloc] init];
    smallScrollView.backgroundColor = [UIColor clearColor];
    smallScrollView.tag = tag;
    smallScrollView.frame = CGRectMake(ScreenWidth*tag, 0, ScreenWidth, ScreenHeight);
    smallScrollView.delegate = self;
    smallScrollView.maximumZoomScale=16.0;
    smallScrollView.minimumZoomScale=1;
    [self.bigScrollView addSubview:smallScrollView];
    
    return smallScrollView;
    
}

- (JLPhoto *)addTapWithTag:(int)tag{
    
    JLPhoto *photo = self.photos[tag];
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTap:)];
    UITapGestureRecognizer *zonmTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zonmTap:)];
    zonmTap.numberOfTapsRequired = 2;
    [photo addGestureRecognizer:zonmTap];
    [photo addGestureRecognizer:photoTap];
    
    //zonmTap失败了再执行photoTap，否则zonmTap永远不会被执行
    [photoTap requireGestureRecognizerToFail:zonmTap];
    
    
    
    
    //hehe
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress11:)];
    [photo addGestureRecognizer:longpress];
    
    
    
    
    return photo;
    
}


- (void)longPress11:(UILongPressGestureRecognizer *)longPress{
//    if(longPress.state == UIGestureRecognizerStateBegan){
//        //全屏
//       float arch = M_PI_2;
//        [self transformViewWitharch:arch];
//
//    }
    
//    [self   showVideo];
    

    [self playVideohehe];
    
    
    
}
#pragma mark 试看
- (void)showVideo{
    
    
    
        
       // NSURL *url = [NSURL URLWithString:_model.url];
        
    
        
        //测试
        self.blackView.backgroundColor = [UIColor yellowColor];
        
        
        /*
        playVC =  [[IJKVideoViewController alloc]initWithURL:url];
        
        
       // [self addChildViewController:playVC];
    
        [self addSubview:playVC.view];
        
        
        
        playVC.view.frame = self.bounds;
        */
        
        
     
    
}








#pragma mark - 动画效果旋转屏幕
-(void)transformViewWitharch:(CGFloat)arch
{
    //对navigationController.view 进行强制旋转
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeRotation(arch);
        
        
            [self p_prepareFullScreen];
            
        
    }];
    
}



- (void)p_prepareFullScreen {
    // [_rotatoButton setTitle:@"竖屏" forState:UIControlStateNormal];
    
    
    
    self.blackView.bounds = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
    NSLog(@"横屏:: %@",NSStringFromCGRect(self.blackView.bounds));
    [self layoutIfNeeded];
    [self layoutSubviews];
    
   // self.blackView.frame =
    
    
    
}







- (JLPieProgressView *)creatLoopWithTag:(int)tag{
    
    JLPieProgressView *loop = [[JLPieProgressView alloc] init];
    loop.tag = tag;
    loop.frame = CGRectMake(0,0 , 80, 80);
    loop.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    loop.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    loop.hidden = YES;
    UITapGestureRecognizer *loopTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopTap:)];
    [loop addGestureRecognizer:loopTap];
    return loop;
    
}

-(void)zonmTap:(UITapGestureRecognizer *)zonmTap{
    
    
    if(flag == 0){
        [UIView animateWithDuration:0.3 animations:^{
        
            UIScrollView *smallScrollView = (UIScrollView *)zonmTap.view.superview;
            smallScrollView.zoomScale = 3.0;
        
             flag = 1;
            
        }];
       
        
    }else if(flag == 1){
        [UIView animateWithDuration:0.3 animations:^{
            
            UIScrollView *smallScrollView = (UIScrollView *)zonmTap.view.superview;
            smallScrollView.zoomScale = 16.0;
            flag = 2;
        }];
        
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            UIScrollView *smallScrollView = (UIScrollView *)zonmTap.view.superview;
            smallScrollView.zoomScale = 1.0;
            flag = 0;
        }];
        
        
    }
    
}

-(void)photoTap:(UITapGestureRecognizer *)photoTap{
    
    //1.将图片缩放回一倍，然后再缩放回原来的frame，否则由于屏幕太小动画直接从3倍缩回去，看不完整
    JLPhoto *photo = (JLPhoto *)photoTap.view;
    UIScrollView *smallScrollView = (UIScrollView *)photo.superview;
    smallScrollView.zoomScale = 1.0;
    
    //1.1如果是长图片先将其移动到CGPointMake(0, 0)在缩放回去 
    if (CGRectGetHeight(photo.frame)>ScreenHeight) {
        smallScrollView.contentOffset = CGPointMake(0, 0);
    }
    
    //2.再取出原始frame，缩放回去
    CGRect frame = [self.originRects[photo.tag] CGRectValue];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        photo.frame = frame;
        self.blackView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

-(void)loopTap:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.blackView.alpha = 0;
        tap.view.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

#pragma mark 获取原始frame

-(void)setupOriginRects{
    
    for (JLPhoto *photo in self.photos) {
        
        UIImageView *sourceImageView = photo.sourceImageView;
        CGRect sourceF = [JLKeyWindow convertRect:sourceImageView.frame fromView:sourceImageView.superview];
        [self.originRects addObject:[NSValue valueWithCGRect:sourceF]];
        
    }
    
}

#pragma mark UIScrollViewDelegate

//告诉scrollview要缩放的是哪个子控件
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    if (scrollView.tag==bigScrollVIewTag) return nil;
    
    JLPhoto *photo = self.photos[scrollView.tag];
    
    return photo;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    if (scrollView.tag==bigScrollVIewTag) return;
    
    JLPhoto *photo = (JLPhoto *)self.photos[scrollView.tag];
    
    CGFloat photoY = (ScreenHeight-photo.frame.size.height)/2;
    CGRect photoF = photo.frame;
    
    if (photoY>0) {
        
        photoF.origin.y = photoY;
        
    }else{
        
        photoF.origin.y = 0;
        
    }
    
    photo.frame = photoF;
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
    //如果结束缩放后scale为1时，跟原来的宽高会有些轻微的出入，导致无法滑动，需要将其调整为原来的宽度
    if (scale == 1.0) {
        
        CGSize tempSize = scrollView.contentSize;
        tempSize.width = ScreenWidth;
        scrollView.contentSize = tempSize;
        CGRect tempF = view.frame;
        tempF.size.width = ScreenWidth;
        view.frame = tempF;
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int currentIndex = scrollView.contentOffset.x/ScreenWidth;
    
    if (self.currentIndex!=currentIndex && scrollView.tag==bigScrollVIewTag) {
        
        self.currentIndex = currentIndex;
        
        for (UIView *view in scrollView.subviews) {
            
            if ([view isKindOfClass:[UIScrollView class]]) {
                
                UIScrollView *scrollView = (UIScrollView *)view;
                scrollView.zoomScale = 1.0;
            }
            
        }
        
    }
    
}

#pragma mark 设置frame

-(void)setFrame:(CGRect)frame{
    
    frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    [super setFrame:frame];
    
}


@end
