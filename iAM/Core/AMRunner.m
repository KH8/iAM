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
    _interval = [[NSNumber alloc] initWithFloat:1.0F];
    _actualInterval = [[NSNumber alloc] initWithFloat:_interval.floatValue];
}

- (void)initRunner{
    [NSThread detachNewThreadSelector:@selector(runBackground) toTarget:self withObject:nil];
}

- (void)runBackground{
    while (true) {
        _tickDateMarker = [NSDate date];
        [_target performSelectorOnMainThread:_selector withObject:nil waitUntilDone:NO];
        if(![_interval isEqualToNumber:_actualInterval]){
            _actualInterval = [[NSNumber alloc] initWithFloat:_interval.floatValue];
        }
        [NSThread sleepForTimeInterval:_actualInterval.floatValue - [_tickDateMarker timeIntervalSinceNow]];
    }
}

- (void)changeIntervalTime:(NSNumber*)intervalTime{
    _interval = intervalTime;
}

@end
