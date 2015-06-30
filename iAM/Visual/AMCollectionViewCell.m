//
//  AMCollectionViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMCollectionViewCell.h"
#import "AMAppearanceManager.h"

@interface AMCollectionViewCell ()

@property(weak, nonatomic) AMNote *noteAssigned;
@property(weak, nonatomic) IBOutlet UIView *rectangleView;

@end

@implementation AMCollectionViewCell

- (void)setNoteAssigned:(AMNote *)aNote {
    _noteAssigned = aNote;
    _noteAssigned.delegate = self;
    [self reloadCell];
}

- (void)reloadCell {
    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7F];
    if (_noteAssigned.isMajorNote) color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4F];
    if (_noteAssigned.isSelected) {
        UIColor *tintColor = [AMAppearanceManager getGlobalTintColor];
        color = [tintColor colorWithAlphaComponent:1.0F];
    }
    if (_noteAssigned.isPlaying) color = [[UIColor whiteColor] colorWithAlphaComponent:0.5F];
    if (_noteAssigned.isTriggered) color = [color colorWithAlphaComponent:0.8F];
    _rectangleView.backgroundColor = color;
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
