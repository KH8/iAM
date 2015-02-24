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
        _numberOfLoops = 0;
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
            _numberOfLoops = 0;
            break;
        case INFINITE_LOOP:
            _stepType = PLAY_ONCE;
            _numberOfLoops = 1;
            break;
    }
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
    AMBar *bar = _mainStave.getActualBar;
    return [NSString stringWithFormat:@"%ld:%ld x%ld %ld BPM",
            (long)bar.getSignatureNumerator,
            (long)bar.getSignatureDenominator,
            (long)bar.getDensity,
            (long)_mainStave.getTempo];
}

- (void)setNumberOfLoops:(NSInteger)newNumberOfLoops{
    _numberOfLoops = newNumberOfLoops;
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
