//
//  AMNote.m
//  iAM
//
//  Created by Krzysztof Reczek on 08.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMNote.h"

@interface AMNote ()

@property (atomic) BOOL selectionState;
@property (atomic) BOOL triggeredState;

@end

@implementation AMNote

-(BOOL)isSelected {
    return _selectionState;
}

- (BOOL)isTriggered {
    return _triggeredState;
}

- (BOOL)isPlaying {
    return _selectionState && _triggeredState;
}

-(void)select {
    _selectionState = !_selectionState;
}

- (void)trigger {
    _triggeredState = !_triggeredState;
    [_delegate noteHasBeenTriggered];
}

- (void)clearTriggerMarker{
    _triggeredState = NO;
    [_delegate noteHasBeenTriggered];
}

@end
