//
//  CustomGCDTimer.m
//  GCDTimer
//
//  Created by xmm on 2020/2/23.
//  Copyright © 2020 xmm. All rights reserved.
//

#import "CustomGCDTimer.h"
@implementation GCDModel

@end

@interface CustomGCDTimer ()

/** 计时器*/
@property (nonatomic, strong) dispatch_source_t timer;
/** 时间间隔*/
@property (nonatomic, assign) NSTimeInterval interval;
/** 开始默认时间*/
@property (nonatomic, assign) NSTimeInterval startInterval;
/** 当前时间*/
@property (nonatomic, assign) NSTimeInterval currentTime;
/** 是否循环*/
@property (nonatomic, assign) BOOL isRepeats;
/** 是否开始*/
@property (nonatomic, assign) BOOL isRun;
/** 是否暂停*/
@property (nonatomic, assign) BOOL isSuspend;


@end

@implementation CustomGCDTimer

//初始化方法
- (instancetype)initWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats task:(task)task complete:(nonnull completetask)completetask{
    self = [super init];
    if (self) {
        self.startInterval = start;
        self.currentTime = start;
        self.interval = interval;
        self.isRepeats = repeats;
        self.taskBlock = task;
        self.completetask = completetask;
        [self creatTimer];
    }
    return self;
}

//创建计时器
- (void)creatTimer {
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(nil, 0), self.interval*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (self.startInterval <0) {
            @throw [NSException exceptionWithName: @"CustomGCDTimer-参数：startInterval配置失败" reason:@"开始时时间不能为小于或等于0" userInfo: nil];
        }
        
        GCDModel *model = [self timeProgress:self.currentTime];
        self.currentTime -= self.interval;
        if (self.currentTime <=0) {
            if (self.taskBlock) {
                self.taskBlock([self timeProgress: 0]);
            }
            if (self.completetask) {
                self.completetask();
            }
            [self cancel];
        }else{
            if (self.taskBlock) {
                self.taskBlock(model);
            }
        }
        
    });
    self.timer = timer;
}

//转换时间模型
- (GCDModel *)timeProgress:(NSTimeInterval)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: time];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm:ss:SSS";
    format.timeZone = [[NSTimeZone alloc] initWithName: @"GMT"];
    NSString *dateValue = [format stringFromDate: date];
    NSArray<NSString *> *timeArray = [dateValue componentsSeparatedByString: @":"];
    
    GCDModel *model = [[GCDModel alloc] init];
    model.hour = timeArray[0];
    model.minute = timeArray[1];
    model.second = timeArray[2];
    return model;
}

//开始计时器
- (void)start {
    if (self.isRun) {
        return;
    }
    if (self.timer) {
        dispatch_resume(self.timer);
        self.isRun = YES;
        self.isSuspend = NO;
    }

}

// 暂停计时器
- (void)suspend {
    if (self.isSuspend) {
        return;
    }
    if (self.timer) {
        dispatch_suspend(self.timer);
        self.isSuspend = YES;
        self.isRun = NO;
    }
    
}

// 停止计时器
- (void)cancel {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}


@end
