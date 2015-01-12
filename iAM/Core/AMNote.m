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

@end

@implementation AMNote

-(BOOL)isSelected{
    return _selectionState;
}

-(void)select{
    _selectionState = !_selectionState;
}

- (void)play {
    [_delegate noteHasBeenTriggered];
}

@end
