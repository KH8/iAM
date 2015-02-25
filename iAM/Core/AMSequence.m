//
//  AMSequence.m
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequence.h"

@interface AMSequence()

@property NSMutableArray *mainSequence;
@property NSUInteger actualIndex;

@property NSInteger actualStepLoopCounter;

@end

@implementation AMSequence

- (id)init {
    self = [super init];
    if (self) {
        _mainSequence = [[NSMutableArray alloc] init];
        [self addNewStep];
        _actualIndex = 0;
        _actualStepLoopCounter = 0;
    }
    return self;
}

- (void)addNewStep{
    NSInteger newIndex = 0;
    if(_mainSequence.count != 0){
        newIndex = _actualIndex + 1;
    }
    [_mainSequence insertObject:[[AMSequenceStep alloc] initWithIndex:_mainSequence.count+1] atIndex:newIndex];
    [self runAllVisualDelegates];
}

- (void)removeStep{
    [self removeStepAtIndex:_actualIndex];
}

- (void)removeStepAtIndex: (NSUInteger)anIndex{
    if(_mainSequence.count == 1){
        return;
    }
    [_mainSequence removeObjectAtIndex:_actualIndex];
    _actualIndex = 0;
    [self runAllVisualDelegates];
    [self runAllMechanicalDelegates];
}

- (NSInteger)getActualIndex{
    return _actualIndex;
}

- (AMSequenceStep*)getNextStep{
    AMSequenceStep *actualStep = [self getActualStep];
    switch (actualStep.getStepType) {
        case PLAY_ONCE:
            [self setIndexAsActual:_actualIndex + 1];
            break;
        case REPEAT:
            if(_actualStepLoopCounter > actualStep.getNumberOfLoops){
                [self setIndexAsActual:_actualIndex + 1];
            }
            break;
        case INFINITE_LOOP:
            break;
    }
    return [self getActualStep];
}


- (AMSequenceStep*)getActualStep{
    return _mainSequence[_actualIndex];
}

- (AMSequenceStep*)getStepAtIndex: (NSUInteger)anIndex{
    return _mainSequence[anIndex];
}

- (void)setIndexAsActual:(NSUInteger)anIndex{
    _actualIndex = anIndex;
    [self runAllMechanicalDelegates];
}

- (void)setOneStepForward{
    NSUInteger maxIndex = _mainSequence.count - 1;
    if(_actualIndex == maxIndex){
        [self setIndexAsActual: 0];
        return;
    }
    [self setIndexAsActual:_actualIndex + 1];
}

- (void)setOneStepBackward{
    NSUInteger maxIndex = _mainSequence.count - 1;
    if(_actualIndex == 0){
        [self setIndexAsActual: maxIndex];
        return;
    }
    [self setIndexAsActual:_actualIndex - 1];
}

- (NSInteger)count{
    return _mainSequence.count;
}

- (void)runAllVisualDelegates{
    [_visualDelegate sequenceHasBeenChanged];
}

- (void)runAllMechanicalDelegates{
    [_visualDelegate stepHasBeenChanged];
    [_mechanicalDelegate stepHasBeenChanged];
}

@end
