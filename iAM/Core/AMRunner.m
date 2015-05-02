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
const float INTERVAL_OFFSET = 0.003F;

@implementation AMRunner

- (id)initWithTickAction:(SEL)selector andTarget:(id)target{
    self = [super init];
    if (self) {
        _selector = selector;
        _target = target;
        [self initParameters];
        [self initRunner];
    }
    return self;
}

- (void)initParameters{
    _interval = [[NSNumber alloc] initWithFloat:INIT_INTERVAL];
    _actualInterval = [[NSNumber alloc] initWithFloat:_interval.floatValue];
}

- (void)initRunner{
    [NSThread detachNewThreadSelector:@selector(runBackground) toTarget:self withObject:nil];
}

- (void)runBackground{
    _tickDateMarker = [NSDate date];
    
    while (true) {
        [_target performSelectorOnMainThread:_selector withObject:nil waitUntilDone:NO];
        [NSThread sleepForTimeInterval:_actualInterval.floatValue - [_tickDateMarker timeIntervalSinceNow] - INTERVAL_OFFSET];
        _tickDateMarker = [NSDate date];
    }
}

- (void)changeIntervalTime:(NSNumber*)intervalTime{
    if(intervalTime.floatValue < SHORTEST_INTERVAL){
        _interval = [[NSNumber alloc] initWithFloat:SHORTEST_INTERVAL];
    }
    else{
        _interval = intervalTime;
    }
    
    if(![_interval isEqualToNumber:_actualInterval]){
        _actualInterval = [[NSNumber alloc] initWithFloat:_interval.floatValue];
    }
}

@end
