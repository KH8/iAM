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
@property (nonatomic) NSDate *creationDate;
@property (nonatomic) NSString *creationDateString;
@property NSMutableArray *mainSequence;
@property NSUInteger actualIndex;

@property NSInteger actualStepLoopCounter;

@end

@implementation AMSequence

- (id)init {
    self = [super init];
    if (self) {
        _name = @"NEW SEQUENCE";
        _mainSequence = [[NSMutableArray alloc] init];
        [self setCreationDate:[NSDate date]];
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

- (void)setCreationDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    _creationDate = date;
    _creationDateString = [formatter stringFromDate:_creationDate];
}

- (NSDate*)getCreationDate{
    return _creationDate;
}

- (NSString*)getCreationDateString{
    return _creationDateString;
}

- (AMSequenceStep*)addNewStep{
    AMSequenceStep *newStep = [[AMSequenceStep alloc] init];
    [self addStep:newStep];
    return newStep;
}

- (void)addStep:(AMSequenceStep*)step{
    NSInteger newIndex = 0;
    if(_mainSequence.count != 0){
        newIndex = _actualIndex + 1;
    }
    [_mainSequence insertObject:step atIndex:newIndex];
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

- (NSMutableArray*)getAllSteps{
    return _mainSequence;
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
