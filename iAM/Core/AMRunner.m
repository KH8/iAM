//
//  AMRunner.m
//  iAM
//
//  Created by Krzysztof Reczek on 19.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMRunner.h"

@interface AMRunner ()

@property NSTimer *mainTimer;
@property SEL selector;
@property id target;

@property NSNumber *interval;
@property NSNumber *actualInterval;

@end

@implementation AMRunner

- (id)initWithTickAction:(SEL)selector andTarget:(id)target{
    self = [super init];
    if (self) {
        _selector = selector;
        _target = target;
        [self initParameters];
        
        _mainTimer = [self createTimer];
        [self initRunnerWithTimer:_mainTimer];
    }
    return self;
}

- (void)onTick{
    if ([_target respondsToSelector:@selector(performSelector:)]) {
        [_target performSelector:_selector];
    }
}

- (void)initParameters{
    _interval = [[NSNumber alloc] initWithFloat:1.0F];
    _actualInterval = [[NSNumber alloc] initWithFloat:_interval.floatValue];
}

- (NSTimer*)createTimer{
    return [NSTimer scheduledTimerWithTimeInterval:_actualInterval.floatValue
                                            target:self
                                          selector:@selector(onTick)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)initRunnerWithTimer:(NSTimer*)timer{
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)changeIntervalTime:(NSNumber*)intervalTime{
    _interval = intervalTime;
    if(![_interval isEqualToNumber:_actualInterval]){
        _actualInterval = [[NSNumber alloc] initWithFloat:_interval.floatValue];
        [_mainTimer invalidate];
        _mainTimer = [self createTimer];
    }
}

@end
