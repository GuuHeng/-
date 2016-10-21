//
//  SliderView.m
//  SlideShowScrollView
//
//  Created by buderui on 16/6/12.
//  Copyright © 2016年 buderui HuHeng. All rights reserved.
//

#import "SliderView.h"



@interface SliderView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *middleImageView;

@property (nonatomic, assign) NSInteger imageIndex;

@property (nonatomic, assign) NSInteger nextIndex;

@end

@implementation SliderView

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    
    self.middleImageView.frame = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    
    self.imageIndex = 0;
    self.pageControl.numberOfPages = _imageArray.count;
    self.pageControl.currentPage = 0;
}

- (void)reloadData
{
    if (self.imageArray.count == 0 || self.imageArray == nil) {
        self.pageControl.hidden = YES;
        self.scrollView.scrollEnabled = NO;
        self.middleImageView.image = [UIImage imageNamed:self.defaultImg];
        return;
    }
    if (self.imageArray.count == 1) {
        self.pageControl.hidden = YES;
        self.scrollView.scrollEnabled = NO;
        self.middleImageView.image = [UIImage imageNamed:self.imageArray[0]];
        return;
    }
    
    self.middleImageView.image = [UIImage imageNamed:self.imageArray[0]];
    
    [self.timer setFireDate:[NSDate dateWithTimeInterval:self.timeInterval sinceDate:[NSDate date]]];
}

- (void)automaticScorll
{
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0) animated:YES];
}

- (void)handlePageControlCurrentPage:(CGFloat)pointX
{
    if (pointX < self.frame.size.width) {

        self.pageControl.currentPage = (self.imageIndex - 1) < 0 ? (self.imageArray.count - 1): (self.imageIndex - 1);
    }
    else if (pointX > self.frame.size.width) {
        
        self.pageControl.currentPage = (self.imageIndex + 1) % self.imageArray.count;
    }
    else {
        self.pageControl.currentPage = self.imageIndex;
    }
    self.middleImageView.tag = self.pageControl.currentPage;
}

- (void)updateImage
{
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.middleImageView.image = self.leftImageView.image;
    self.imageIndex = self.nextIndex;
    self.pageControl.currentPage = self.imageIndex;
    self.middleImageView.tag = self.pageControl.currentPage;
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    
    if (x < self.bounds.size.width) {
        self.leftImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.nextIndex = self.imageIndex - 1;
        self.nextIndex = self.nextIndex >= 0 ? self.nextIndex : (self.imageArray.count - 1);
        self.leftImageView.image = [UIImage imageNamed:self.imageArray[self.nextIndex]];
        
        if (x <= 0) {
            
            [self updateImage];
            
        }
        
    }
    else if (x > self.bounds.size.width) {
        
        self.leftImageView.frame = CGRectMake(CGRectGetMaxX(self.middleImageView.frame), 0, self.bounds.size.width, self.bounds.size.height);
        self.nextIndex = (self.imageIndex + 1) % self.imageArray.count;
        self.leftImageView.image = [UIImage imageNamed:self.imageArray[self.nextIndex]];
        
        if (x >= self.bounds.size.width * 2) {
            
            [self updateImage];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    [self handlePageControlCurrentPage:x];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.timer setFireDate:[NSDate dateWithTimeInterval:self.timeInterval sinceDate:[NSDate date]]];
}

#pragma mark - Getter

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(automaticScorll) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
        _pageControl.backgroundColor = [UIColor blueColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;

        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _leftImageView = [[UIImageView alloc] init];
        [_scrollView addSubview:_leftImageView];
        
        _middleImageView = [[UIImageView alloc] init];
        _middleImageView.userInteractionEnabled = YES;
        [_scrollView addSubview:_middleImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderViewTapSEL:)];
        [_middleImageView addGestureRecognizer:tap];
        
    }
    return _scrollView;
}

- (void)sliderViewTapSEL:(UITapGestureRecognizer *)tap
{
    UIImageView *view = (UIImageView *)tap.view;
    NSLog(@"view.tag%lu", view.tag);
}

@end
