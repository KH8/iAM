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
@property (atomic) BOOL majorNoteState;

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

- (BOOL)isMajorNote {
    return _majorNoteState;
}

-(void)select {
    _selectionState = !_selectionState;
    [_delegate noteStateHasBeenChanged];
}

- (void)trigger {
    _triggeredState = !_triggeredState;
    [_delegate noteStateHasBeenChanged];
}

- (void)clearTriggerMarker{
    if(_triggeredState == NO) return;
    _triggeredState = NO;
    [_delegate noteStateHasBeenChanged];
}

- (void)setAsMajorNoteState{
    if(_majorNoteState == YES) return;
    _majorNoteState = YES;
    [_delegate noteStateHasBeenChanged];
}

- (void)resetAsMajorNoteState{
    if(_majorNoteState == NO) return;
    _majorNoteState = NO;
    [_delegate noteStateHasBeenChanged];
}

@end
