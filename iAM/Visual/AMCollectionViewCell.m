//
//  AMCollectionViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMCollectionViewCell.h"

@interface AMCollectionViewCell()

@property (weak, nonatomic) AMNote *noteAssigned;

@end

@implementation AMCollectionViewCell

- (void)setNoteAssigned:(AMNote *)aNote {
    _noteAssigned = aNote;
    _noteAssigned.delegate = self;
    [self reloadCell];
}

- (void)reloadCell {
    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5F];
    if(_noteAssigned.isMajorNote) color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7F];
    if(_noteAssigned.isSelected) color = [[UIColor grayColor] colorWithAlphaComponent:0.7F];
    if(_noteAssigned.isPlaying) color = [[UIColor greenColor] colorWithAlphaComponent:0.5F];
    if(_noteAssigned.isTriggered) color = [color colorWithAlphaComponent:0.2F];
    self.backgroundColor = color;
}

- (void)touch {
    [_noteAssigned select];
}

- (void)noteStateHasBeenChanged {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadCell];
    });
}


@end
