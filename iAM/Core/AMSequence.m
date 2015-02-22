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
@property NSInteger actualIndex;

@end

@implementation AMSequence

- (id)init {
    self = [super init];
    if (self) {
        _mainSequence = [[NSMutableArray alloc] init];
        [self addNewStep];
        _actualIndex = 0;
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
}

- (NSInteger)getActualIndex{
    return _actualIndex;
}

- (AMSequenceStep*)getNextStep{
    return _mainSequence[_actualIndex];
}

- (AMSequenceStep*)getStepAtIndex: (NSUInteger)anIndex{
    return _mainSequence[anIndex];
}

- (void)setIndexAsActual:(NSUInteger)anIndex{
    _actualIndex = anIndex;
    [_delegate selectionHasBeenChanged];
}

- (NSInteger)count{
    return _mainSequence.count;
}

- (void)runAllVisualDelegates{
    [_delegate sequenceHasBeenChanged];
}

@end
