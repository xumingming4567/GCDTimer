//
//  ViewController.m
//  GCDTimer
//
//  Created by xmm on 2020/2/22.
//  Copyright © 2020 xmm. All rights reserved.
//

#import "ViewController.h"
#import "CustomGCDTimer.h"

@interface ViewController ()
@property (nonatomic, strong) CustomGCDTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, self.view.frame.size.width - 200, 40)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:32];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    NSArray *array = @[@"开始",@"暂停"];
    for (NSInteger i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50 + i*150, 200, 100, 50);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        [btn setTitleColor:[UIColor systemPinkColor] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    CustomGCDTimer *timer = [[CustomGCDTimer alloc] initWithStart:60 interval:1 repeats:YES task:^(GCDModel * _Nonnull time) {
        NSLog(@"%@:%@:%@",time.hour,time.minute,time.second);
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = [NSString stringWithFormat:@"%@:%@:%@",time.hour,time.minute,time.second];
        });
    } complete:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            label.text = @"倒计时结束";
        });
    }];
    [timer start];
    self.timer = timer;
    
    
}

- (void)btnClicked:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.timer start];
    }else{
        [self.timer suspend];
    }
}

@end
