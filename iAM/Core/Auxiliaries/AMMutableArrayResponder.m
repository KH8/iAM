//
// Created by Krzysztof Reczek on 03.04.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMMutableArrayResponder.h"

@interface AMMutableArrayResponder ()

@property SEL arrayHasChangedSelector;
@property SEL selectionHasChangedSelector;
@property id target;

@end

@implementation AMMutableArrayResponder {

}

- (id)initWithArrayHasChangedAction:(SEL)arrayHasChangedSelector
       andSelectionHasChangedAction:(SEL)selectionHasChangedSelector
                          andTarget:(id)target{
    self = [super init];
    if (self) {
        _arrayHasChangedSelector = arrayHasChangedSelector;
        _selectionHasChangedSelector = selectionHasChangedSelector;
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

@end