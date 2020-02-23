//
//  CustomGCDTimer.h
//  GCDTimer
//
//  Created by xmm on 2020/2/23.
//  Copyright © 2020 xmm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**  计时器的模型*/
@interface GCDModel : NSObject

@property (nonatomic, copy) NSString *hour;//时
@property (nonatomic, copy) NSString *minute;//分
@property (nonatomic, copy) NSString *second;//秒

@end

/**事件回调*/
typedef void(^task)(GCDModel *time);
/**结束回调*/
typedef void(^completetask)(void);


@interface CustomGCDTimer : NSObject

/** 计时器的回调*/
@property (nonatomic, copy) task taskBlock;

/** 计时器完成的回调*/
@property (nonatomic, copy) completetask completetask;

/**
@param start 其实时间值
@param interval 每隔多少秒回调一次
@param repeats 是否要重复
@param task 回调
*/
- (instancetype)initWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats task:(task)task complete:(completetask)completetask;

/**
 计时器开始
*/
-(void)start;

/**
 计时器暂停
*/
-(void)suspend;

/**
 停止计时器
*/
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
