//
//  SliderView.h
//  SlideShowScrollView
//
//  Created by buderui on 16/6/12.
//  Copyright © 2016年 buderui HuHeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderView : UIView

/**
 *  存储图片 数组
 */
@property (nonatomic, strong) NSArray *imageArray;

/**
 *  动画切换的时间间隔
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/**
 *  图片数组为空时，请给出默认底图
 */
@property (nonatomic, copy) NSString *defaultImg;

/**
 * 刷新数据
 */
- (void)reloadData;




@end
