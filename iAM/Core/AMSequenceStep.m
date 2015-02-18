//
//  AMSequenceStep.m
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceStep.h"

@interface AMSequenceStep()

@property AMStave *mainStave;
@property StepType stepType;

@end

@implementation AMSequenceStep

- (id)init {
    self = [super init];
    if (self) {
        _mainStave = [[AMStave alloc] init];
        _stepType = INFINITE_LOOP;
    }
    return self;
}

- (AMStave*)getStave{
    return _mainStave;
}

- (void)setNextStepType{
    
}

- (StepType)getStepType{
    return _stepType;
}

@end
