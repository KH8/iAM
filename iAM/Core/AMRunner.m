//
//  AMRunner.m
//  iAM
//
//  Created by Krzysztof Reczek on 19.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMRunner.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>

@interface AMRunner ()

@property SEL selector;
@property id target;

@property NSNumber *interval;
@property NSNumber *actualInterval;
@property CADisplayLink *syncTimer;

@end

const float INIT_INTERVAL = 1.0F;
const float SHORTEST_INTERVAL = 0.05F;
const float INTERVAL_OFFSET = 0.002F;

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
    _syncTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(syncFired:)];
    [self updateActualInterval];
    [_syncTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [_syncTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

-(void)syncFired:(CADisplayLink *)displayLink
{
    [_target performSelectorOnMainThread:_selector withObject:nil waitUntilDone:NO];
    [self updateActualInterval];
}

- (void)updateActualInterval {
    if (![_interval isEqualToNumber:_actualInterval]) {
        _actualInterval = [[NSNumber alloc] initWithFloat:_interval.floatValue];
        _syncTimer.frameInterval = _actualInterval.floatValue * 60.0f;
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
