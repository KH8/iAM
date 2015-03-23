//
//  AMSequence.m
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequence.h"

@interface AMSequence()

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *creationDate;
@property NSMutableArray *mainSequence;
@property NSUInteger actualIndex;

@property NSInteger actualStepLoopCounter;

@end

@implementation AMSequence

- (id)init {
    self = [super init];
    if (self) {
        _name = @"NEW SEQUENCE";
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        _creationDate = [formatter stringFromDate:[NSDate date]];
        
        _mainSequence = [[NSMutableArray alloc] init];
        [self addNewStep];
        _actualIndex = 0;
        _actualStepLoopCounter = 0;
    }
    return self;
}

- (void)setName:(NSString*)newName{
    _name = newName;
    [self runAllVisualDelegates];
}

- (NSString*)getName{
    return _name;
}

- (NSString*)getCreationDate{
    return _creationDate;
}

- (AMSequenceStep*)addNewStep{
    NSInteger newIndex = 0;
    if(_mainSequence.count != 0){
        newIndex = _actualIndex + 1;
    }
    AMSequenceStep *newStep = [[AMSequenceStep alloc] init];
    [_mainSequence insertObject:newStep atIndex:newIndex];
    [self runAllVisualDelegates];
    
    return newStep;
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
            [self setOneStepForward];
            break;
        case REPEAT:
            _actualStepLoopCounter++;
            if(_actualStepLoopCounter == actualStep.getNumberOfLoops){
                [self setOneStepForward];
                break;
            }
            break;
        case INFINITE_LOOP:
            break;
    }
    [self runAllMechanicalDelegates];
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
    _actualStepLoopCounter = 0;
    
    NSUInteger maxIndex = _mainSequence.count - 1;
    if(_actualIndex == maxIndex){
        [self setIndexAsActual: 0];
        return;
    }
    [self setIndexAsActual:_actualIndex + 1];
}

- (void)setOneStepBackward{
    _actualStepLoopCounter = 0;
    
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
