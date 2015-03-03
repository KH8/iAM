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
@property StepType stepType;

@property AMStave *mainStave;
@property (nonatomic) NSInteger numberOfLoops;

@end

@implementation AMSequenceStep

- (id)initWithIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _name = [NSString stringWithFormat:@"STEP %ld", (long)index];
        _mainStave = [[AMStave alloc] init];
        _stepType = INFINITE_LOOP;
        _numberOfLoops = 1;
    }
    return self;
}

- (AMStave*)getStave{
    return _mainStave;
}

- (void)setNextStepType{
    switch (_stepType)
    {
        case PLAY_ONCE:
            _stepType = REPEAT;
            break;
        case REPEAT:
            _stepType = INFINITE_LOOP;
            _numberOfLoops = 1;
            break;
        case INFINITE_LOOP:
            _stepType = PLAY_ONCE;
            _numberOfLoops = 1;
            break;
    }
    [_visualDelegate sequenceStepPropertiesHasBeenChanged];
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
    if(_mainStave.getSize == 1){
        bar = @"BAR";
    }
    return [NSString stringWithFormat:@"%ld %@ %ld BPM",
            (long)_mainStave.getSize,
            bar,
            (long)_mainStave.getTempo];
}

- (void)incrementLoop{
    _numberOfLoops++;
    [_visualDelegate sequenceStepPropertiesHasBeenChanged];
}

- (void)decrementLoop{
    if(_numberOfLoops == 1){
        return;
    }
    _numberOfLoops--;
    [_visualDelegate sequenceStepPropertiesHasBeenChanged];
}

- (NSInteger)getNumberOfLoops{
    return _numberOfLoops;
}

- (BOOL)isNumberOfLoopsAvailable{
    BOOL response = NO;
    if(_stepType == REPEAT){
        response = YES;
    }
    return response;
}

@end
