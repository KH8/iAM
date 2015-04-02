//
// Created by Krzysztof Reczek on 05.02.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMStave.h"

@interface AMStave ()

@property (nonatomic) NSInteger tempo;
@property (nonatomic) NSDate *lastTapTime;

@property (nonatomic, strong) NSHashTable *staveDelegates;

@end

@implementation AMStave

NSUInteger const maxTempo = 300;
NSUInteger const minTempo = 60;

- (void)addStaveDelegate: (id<AMStaveDelegate>)delegate{
    [_staveDelegates addObject: delegate];
}

- (void)removeStaveDelegate: (id<AMStaveDelegate>)delegate{
    [_staveDelegates removeObject: delegate];
}

- (void)delegateTempoHasBeenChanged{
    for (id<AMStaveDelegate> delegate in _staveDelegates) {
        [delegate tempoHasBeenChanged];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        [self initBasicParameters];
    }
    return self;
}

- (id)initWithSubComponents{
    self = [self init];
    if (self) {
        [self addBar];
    }
    return self;
}

- (void)initBasicParameters {
    _tempo = 120;
    _maxTempo = maxTempo;
    _minTempo = minTempo;
    _lastTapTime = [NSDate date];
}

- (void)setTempo:(NSInteger)aTempo {
    _tempo = aTempo;
    [self delegateTempoHasBeenChanged];
}

- (NSInteger)getTempo {
    return _tempo;
}

- (void)tapTempo {
    NSDate *actualTapTime = [NSDate date];
    NSTimeInterval executionTime = [actualTapTime timeIntervalSinceDate:_lastTapTime];
    _lastTapTime = actualTapTime;
    NSNumber *intervalSinceLastTapInMilliseconds = @(executionTime * 1000.0f);
    
    if(intervalSinceLastTapInMilliseconds.floatValue > 1000.0f){
        return;
    }
    if(intervalSinceLastTapInMilliseconds.floatValue < 200.0f){
        return;
    }
    
    NSNumber *newTempo = @(60000.0f / intervalSinceLastTapInMilliseconds.floatValue);
    [self setTempo:newTempo.integerValue];
}

- (void)addBar{
    AMBar *newBar = [[AMBar alloc] init];
    [newBar configureDefault];
    [self addObject:newBar];
}

@end