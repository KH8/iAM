//
// Created by Krzysztof Reczek on 03.04.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMMutableArrayResponder.h"

@interface AMMutableArrayResponder ()

@property SEL arrayHasChangedSelector;
@property SEL selectionHasChangedSelector;
@property SEL maxCountExceededSelector;
@property id target;

@end

@implementation AMMutableArrayResponder {

}

- (id)initWithArrayHasChangedAction:(SEL)arrayHasChangedSelector
       andSelectionHasChangedAction:(SEL)selectionHasChangedSelector
        andMaxCountExceededAction:(SEL)maxCountExceededSelector
                          andTarget:(id)target{
    self = [super init];
    if (self) {
        _arrayHasChangedSelector = arrayHasChangedSelector;
        _selectionHasChangedSelector = selectionHasChangedSelector;
        _maxCountExceededSelector = maxCountExceededSelector;
        _target = target;
    }
    return self;
}

- (void)arrayHasBeenChanged {
    [_target performSelector:_arrayHasChangedSelector];
}

- (void)selectionHasBeenChanged {
    [_target performSelector:_selectionHasChangedSelector];
}

- (void)maxCountExceeded {
    [_target performSelector:_maxCountExceededSelector];
}

@end