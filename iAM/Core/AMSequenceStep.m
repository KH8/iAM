//
//  AMSequenceStep.m
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceStep.h"

@interface AMSequenceStep ()

@property(nonatomic) NSString *name;
@property(nonatomic) StepType stepType;

@property AMStave *mainStave;
@property(nonatomic) NSInteger numberOfLoops;

@property(nonatomic, strong) NSHashTable *stepDelegates;

@property NSDate *lastIncrementationDate;
@property NSDate *firstIncrementationDate;

@end

@implementation AMSequenceStep

- (void)addStepDelegate:(id <AMSequenceStepDelegate>)delegate {
    [_stepDelegates addObject:delegate];
}

- (void)removeStepDelegate:(id <AMSequenceStepDelegate>)delegate {
    [_stepDelegates removeObject:delegate];
}

- (void)delegateStepPropertyHasBeenChanged {
    for (id <AMSequenceStepDelegate> delegate in _stepDelegates) {
        [delegate sequenceStepPropertiesHasBeenChanged];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        _name = @"NEW STEP";
        _stepType = INFINITE_LOOP;
        _numberOfLoops = 1;
        _stepDelegates = [NSHashTable weakObjectsHashTable];
        _lastIncrementationDate = [NSDate date];
        _firstIncrementationDate = [NSDate date];
    }
    return self;
}

- (id)initWithSubComponents {
    self = [self init];
    if (self) {
        AMStave *newStave = [[AMStave alloc] initWithSubComponents];
        [self setStave:newStave];
    }
    return self;
}

- (void)setStave:(AMStave *)stave {
    _mainStave = stave;
    [self delegateStepPropertyHasBeenChanged];
}

- (AMStave *)getStave {
    return _mainStave;
}

- (void)setNextStepType {
    switch (_stepType) {
        case PLAY_ONCE:
            [self setStepType:REPEAT];
            break;
        case REPEAT:
            [self setStepType:INFINITE_LOOP];
            break;
        case INFINITE_LOOP:
            [self setStepType:PLAY_ONCE];
            break;
    }
}

- (void)setStepType:(StepType)stepType {
    _stepType = stepType;
    [self delegateStepPropertyHasBeenChanged];
}

- (StepType)getStepType {
    return _stepType;
}

- (NSString *)getStepTypeName {
    return [self stepTypeToString:_stepType];
}

- (void)setName:(NSString *)newName {
    _name = [NSString stringWithFormat:@"%@", newName];
}

- (NSString *)getName {
    return _name;
}

- (NSString *)getDescription {
    NSString *bar = @"BARS";
    if (_mainStave.count == 1) {
        bar = @"BAR";
    }
    NSString *description = [NSString stringWithFormat:
                             @"%ld %@ %ld BPM", (long) _mainStave.count, bar, (long) _mainStave.getTempo];

    if (_stepType == REPEAT) {
        return [NSString stringWithFormat:
                @" %@ x%ld", description, (long) _numberOfLoops];
    }

    return description;
}

- (void)incrementLoop {
    _numberOfLoops += [self getIncrementFactor];
    if (_numberOfLoops > 999) {
        _numberOfLoops = 999;
    }
    [self delegateStepPropertyHasBeenChanged];
}

- (void)decrementLoop {
    _numberOfLoops -= [self getIncrementFactor];
    if (_numberOfLoops < 1) {
        _numberOfLoops = 1;
    }
    [self delegateStepPropertyHasBeenChanged];
}

- (int)getIncrementFactor {
    float intervalFromFirstInc = -1.0f * [_firstIncrementationDate timeIntervalSinceNow];
    float intervalFromLastInc = -1.0f * [_lastIncrementationDate timeIntervalSinceNow];
    _lastIncrementationDate = [NSDate date];
    int value = 1;
    if(intervalFromLastInc > 0.5) {
        _firstIncrementationDate = [NSDate date];
    } else {
        if(intervalFromFirstInc > 2.0) {
            value =  10;
        }
    }
    return value;
}

- (void)setNumberOfLoops:(NSInteger)numberOfLoops {
    _numberOfLoops = numberOfLoops;
}

- (NSInteger)getNumberOfLoops {
    return _numberOfLoops;
}

- (NSInteger)stepTypeToInteger:(StepType)stepType {
    switch (stepType) {
        case PLAY_ONCE:
            return 1;
        case REPEAT:
            return 2;
        case INFINITE_LOOP:
            return 3;
        default:
            return 1;
    }
}

- (NSString *)stepTypeToString:(StepType)stepType {
    switch (stepType) {
        case PLAY_ONCE:
            return @"PLAY ONCE";
        case REPEAT:
            return @"REPEAT";
        case INFINITE_LOOP:
            return @"INFINITE LOOP";
        default:
            return @"";
    }
}

- (StepType)integerToStepType:(NSInteger)stepTypeValue {
    switch (stepTypeValue) {
        case 1:
            return PLAY_ONCE;
        case 2:
            return REPEAT;
        case 3:
            return INFINITE_LOOP;
        default:
            return PLAY_ONCE;
    }
}

- (id)clone {
    AMSequenceStep *clone = [[AMSequenceStep alloc] init];
    [clone setName:[NSString stringWithString:_name]];
    [clone setStepType:_stepType];
    [clone setNumberOfLoops:_numberOfLoops];
    [clone setMainStave:_mainStave.clone];
    return clone;
}

@end
