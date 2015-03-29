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

@end

@implementation AMSequenceStep

- (id)init {
    self = [super init];
    if (self) {
        _name = @"NEW STEP";
        _mainStave = [[AMStave alloc] init];
        _stepType = INFINITE_LOOP;
        _numberOfLoops = 1;
    }
    return self;
}

- (id)initWithSubComponents {
    self = [self init];
    if (self) {
        _mainStave = [[AMStave alloc] initWithSubComponents];
    }
    return self;
}

- (AMStave*)getStave{
    return _mainStave;
}

- (void)setStepTypeFromInteger:(NSInteger)stepType{
    switch (_stepType)
    {
        case 1:
            _stepType = PLAY_ONCE;
            break;
        case 2:
            _stepType = REPEAT;
            break;
        case 3:
            _stepType = INFINITE_LOOP;
            break;
    }
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
    NSString *description = [NSString stringWithFormat:@"%ld %@ %ld BPM",
                           (long)_mainStave.getSize,
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
    [_visualDelegate sequenceStepPropertiesHasBeenChanged];
}

- (void)decrementLoop{
    if(_numberOfLoops == 1){
        return;
    }
    _numberOfLoops--;
    [_visualDelegate sequenceStepPropertiesHasBeenChanged];
}

- (void)setNumberOfLoops:(NSInteger)numberOfLoops{
    _numberOfLoops = numberOfLoops;
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
