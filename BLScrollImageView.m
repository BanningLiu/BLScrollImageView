//
//  BLScrollImageView.m
//  MultipeerConnectivityDemo
//
//  Created by BanglinLiu on 16/2/17.
//  Copyright © 2016年 banning. All rights reserved.
//

#import "BLScrollImageView.h"

@interface BLScrollImageView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BLScrollImageView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.images = [NSMutableArray array];
    [self.images addObjectsFromArray:images];
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    [self initTimer];
    
    return self;
}

#pragma mark - using lazy loading

- (UIScrollView*)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        //设置contentsize
        _scrollView.contentSize = CGSizeMake(_images.count * CGRectGetWidth(self.frame), 0);
        
        [self addImageView:_images];
    }
    return _scrollView;
}

- (UIPageControl*)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame) / 2 - 50, CGRectGetHeight(self.scrollView.frame) - 30, 100, 15)];
        _pageControl.numberOfPages = self.images.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:205/255.0 alpha:1];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    }
    
    return _pageControl;
}

//需考虑可能是使用URL
- (void)addImageView:(NSArray *)images{
    float imageWidth = CGRectGetWidth(self.frame);
    if (_images.count > 0) {
        for (int i = 0; i < _images.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * imageWidth, 0, imageWidth, CGRectGetHeight(self.frame))];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageNamed:_images[i]];
            [self.scrollView addSubview:imageView];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollviewW =  CGRectGetWidth(scrollView.frame);
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollviewW / 2) /  scrollviewW;
    self.pageControl.currentPage = page;
}

//开始滚动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self closeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self initTimer];
}

#pragma mark - private method

- (void)showImage{
    NSInteger curPage = self.pageControl.currentPage;
    if (curPage == self.images.count - 1) {
        curPage = 0;
    }else{
        curPage++;
    }
    
    CGFloat x = curPage * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(x, 0);
}

- (void)initTimer{
    self.timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(showImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)closeTimer{
    if (self.timer) {
        [self.timer invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
