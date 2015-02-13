//
// Created by Krzysztof Reczek on 05.02.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMStave.h"

@interface AMStave ()

@property (nonatomic) NSInteger tempo;
@property (nonatomic) NSMutableArray *arrayOfBars;
@property (nonatomic) NSInteger actualIndex;
@property (nonatomic) AMBar *previousBar;

@end

@implementation AMStave

NSUInteger const maxTempo = 300;
NSUInteger const minTempo = 60;

- (id)init {
    self = [super init];
    if (self) {
        _actualIndex = 0;
        _arrayOfBars = [[NSMutableArray alloc] init];
        [self addBar];
        [self initBasicParameters];
        _previousBar = _arrayOfBars[0];
    }
    return self;
}

- (void)initBasicParameters {
    _tempo = 120;

    _maxTempo = maxTempo;
    _minTempo = minTempo;
}

- (void)setTempo:(NSInteger)aTempo {
    _tempo = aTempo;
    [_mechanicalDelegate tempoHasBeenChanged];
}

- (NSInteger)getTempo {
    return _tempo;
}

- (void)addBar {
    AMBar *newBar = [[AMBar alloc] init];
    newBar.staveDelegate = self;
    [newBar configureDefault];
    
    NSInteger newIndex = 0;
    if(_arrayOfBars.count != 0){
        newIndex = _actualIndex + 1;
    }
    
    [_arrayOfBars insertObject:newBar atIndex:newIndex];
    [self runAllVisualDelegates];
}

- (void)removeActualBar {
    if(_arrayOfBars.count == 1){
        return;
    }
    AMBar *barToBeRemoved = [self getActualBar];
    [_arrayOfBars removeObject:barToBeRemoved];
    if(_actualIndex >= _arrayOfBars.count) _actualIndex = 0;
    [self runAllVisualDelegates];
}

- (void)runAllVisualDelegates{
    [_visualDelegate barHasBeenChanged];
    [_visualPageViewDelegate barHasBeenChanged];
    [_mechanicalDelegate barHasBeenChanged];
}

- (void)setFirstBarAsActual {
    _actualIndex = 0;
    [self runAllVisualDelegates];
}

- (void)setNextBarAsActual {
    _actualIndex++;
    if(_actualIndex >= _arrayOfBars.count) _actualIndex = 0;
    [self runAllVisualDelegates];
}

- (void)setIndexAsActual: (NSUInteger)index{
    _actualIndex = index;
    if(_actualIndex >= _arrayOfBars.count) _actualIndex = 0;
    [self runAllVisualDelegates];
}

- (AMBar *)getActualBar {
    AMBar *actualBar = _arrayOfBars[(NSUInteger) _actualIndex];
    if(actualBar != _previousBar){
        [_previousBar clearTriggerMarkers];
        _previousBar = actualBar;
    }
    return actualBar;
}

- (NSInteger)getActualIndex {
    return _actualIndex;
}

- (NSInteger)getSize{
    return _arrayOfBars.count;
}

- (void)signatureHasBeenChanged{
    [self runAllVisualDelegates];
}

@end