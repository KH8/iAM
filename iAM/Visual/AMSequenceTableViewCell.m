//
//  AMSequenceTableViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceTableViewCell.h"
#import "AMSequenceStep.h"

@interface AMSequenceTableViewCell ()

@property AMSequenceStep *sequenceStep;

@end

@implementation AMSequenceTableViewCell

- (void)awakeFromNib {
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4F];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)assignSequenceStep: (AMSequenceStep*)aStep{
    _sequenceStep = aStep;
    _stepTitle.text = _sequenceStep.getName;
    _stepSubtitle.text = _sequenceStep.getDescription;
}

- (IBAction)newLabelEntered:(id)sender {
    [_sequenceStep setName:_stepTitle.text];
}

@end
