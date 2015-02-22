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

@end

@implementation AMSequenceStep

- (id)initWithIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _name = [NSString stringWithFormat:@"STEP %ld", (long)index];
        _mainStave = [[AMStave alloc] init];
        _stepType = INFINITE_LOOP;
    }
    return self;
}

- (AMStave*)getStave{
    return _mainStave;
}

- (void)setNextStepType{
    _stepType += 1;
    if(_stepType > 3){
        _stepType = 1;
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

@end
