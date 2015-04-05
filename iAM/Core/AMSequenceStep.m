//
//  AMSequenceStep.m
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceStep.h"

@interface AMSequenceStep()

@property (nonatomic) NSString *name;
@property (nonatomic) StepType stepType;

@property AMStave *mainStave;
@property (nonatomic) NSInteger numberOfLoops;

@property (nonatomic, strong) NSHashTable *stepDelegates;

@end

@implementation AMSequenceStep

- (void)addStepDelegate: (id<AMSequenceStepDelegate>)delegate{
    [_stepDelegates addObject: delegate];
}

- (void)removeStepDelegate: (id<AMSequenceStepDelegate>)delegate{
    [_stepDelegates removeObject: delegate];
}

- (void)delegateStepPropertyHasBeenChanged{
    for (id<AMSequenceStepDelegate> delegate in _stepDelegates) {
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

- (void)setStave:(AMStave *)stave{
    _mainStave = stave;
    [self delegateStepPropertyHasBeenChanged];
}

- (AMStave*)getStave{
    return _mainStave;
}

- (void)setNextStepType{
    switch (_stepType)
    {
        case PLAY_ONCE:
            [self setStepType:REPEAT];
            break;
        case REPEAT:
            [self setStepType:INFINITE_LOOP];
            _numberOfLoops = 1;
            break;
        case INFINITE_LOOP:
            [self setStepType:PLAY_ONCE];
            _numberOfLoops = 1;
            break;
    }
}

- (void)setStepType:(StepType)stepType{
    _stepType = stepType;
    [self delegateStepPropertyHasBeenChanged];
}

- (StepType)getStepType{
    return _stepType;
}

- (void)setName: (NSString*)newName{
    _name = [NSString stringWithFormat:@"%@", newName];
}

- (NSString*)getName{
    return _name;
}

- (NSString*)getDescription{
    NSString *bar = @"BARS";
    if(_mainStave.count == 1){
        bar = @"BAR";
    }
    NSString *description = [NSString stringWithFormat:@"%ld %@ %ld BPM",
                           (long)_mainStave.count,
                           bar,
                           (long)_mainStave.getTempo];
    
    if(_stepType == REPEAT){
        return [NSString stringWithFormat:@" %@ x%ld",
                description,
                (long)_numberOfLoops];
    }
    
    return description;
}

- (void)incrementLoop{
    _numberOfLoops++;
    [self delegateStepPropertyHasBeenChanged];
}

- (void)decrementLoop{
    if(_numberOfLoops == 1){
        return;
    }
    _numberOfLoops--;
    [self delegateStepPropertyHasBeenChanged];
}

- (void)setNumberOfLoops:(NSInteger)numberOfLoops{
    _numberOfLoops = numberOfLoops;
}

- (NSInteger)getNumberOfLoops{
    return _numberOfLoops;
}

- (NSInteger)stepTypeToInteger:(StepType)stepType{
    switch (stepType)
    {
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

- (StepType)integerToStepType:(NSInteger)stepTypeValue{
    switch (stepTypeValue)
    {
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

@end
