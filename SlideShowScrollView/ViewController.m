//
//  ViewController.m
//  SlideShowScrollView
//
//  Created by buderui on 16/6/12.
//  Copyright © 2016年 buderui HuHeng. All rights reserved.
//

#import "ViewController.h"
#import "SliderView.h"

@interface ViewController ()
@property (nonatomic, strong) SliderView *slide;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor purpleColor];
    self.slide = [[SliderView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 400)];
    self.slide.backgroundColor = [UIColor orangeColor];
    self.slide.imageArray = @[@"1111", @"2222", @"3333"];
    self.slide.timeInterval = 5;
    [self.slide reloadData];
    [self.view addSubview:self.slide];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
