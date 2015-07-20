//
//  AMRunner.m
//  iAM
//
//  Created by Krzysztof Reczek on 19.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMRunner.h"

@interface AMRunner ()

@property SEL selector;
@property id target;

@property NSNumber *interval;
@property NSNumber *actualInterval;
@property NSDate *tickDateMarker;

@property NSThread *thread;

@end

const float INIT_INTERVAL = 1.0F;
const float SHORTEST_INTERVAL = 0.05F;
const float SHORTEST_LOOP_INTERVAL = 0.00005F;
const float DIVISOR = 2.0F;

@implementation AMRunner

- (id)initWithTickAction:(SEL)selector andTarget:(id)target {
    self = [super init];
    if (self) {
        _selector = selector;
        _target = target;
        [self initParameters];
        [self initRunner];
    }
    return self;
}

- (void)initParameters {
    _interval = [[NSNumber alloc] initWithFloat:INIT_INTERVAL];
    _actualInterval = [[NSNumber alloc] initWithFloat:_interval.floatValue];
}

- (void)initRunner {
    [NSThread detachNewThreadSelector:@selector(runBackground) toTarget:self withObject:nil];
}

- (void)runBackground {
    _tickDateMarker = [NSDate date];
    bool tick = true;

    while (true) {
        if(tick) {
            _tickDateMarker = [NSDate date];
            [_target performSelectorOnMainThread:_selector withObject:nil waitUntilDone:NO];
            [self updateActualInterval];
            tick = NO;
        }
        float realInterval = -1.0f * [_tickDateMarker timeIntervalSinceNow];
        if(realInterval >= _actualInterval.floatValue) {
            tick = YES;
        }
        float interval = MAX(SHORTEST_LOOP_INTERVAL, ( _actualInterval.floatValue - realInterval ) / DIVISOR);
        [NSThread sleepForTimeInterval:interval];
    }
}

- (void)updateActualInterval {
    if (![_interval isEqualToNumber:_actualInterval]) {
        _actualInterval = [[NSNumber alloc] initWithFloat:_interval.floatValue];
    }
}

- (void)changeIntervalTime:(NSNumber *)intervalTime {
    if (intervalTime.floatValue < SHORTEST_INTERVAL) {
        _interval = [[NSNumber alloc] initWithFloat:SHORTEST_INTERVAL];
    }
    else {
        _interval = intervalTime;
    }
}

@end
