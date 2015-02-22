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
    [self adjustTextFieldsFrame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_stepTitle resignFirstResponder];
}

- (void)assignSequenceStep: (AMSequenceStep*)aStep{
    _sequenceStep = aStep;
    _stepTitle.text = _sequenceStep.getName;
    _stepSubtitle.text = _sequenceStep.getDescription;
    self.accessoryType = [self acquireButtonAdequateForStepType:aStep];
}

- (UITableViewCellAccessoryType)acquireButtonAdequateForStepType: (AMSequenceStep*)aStep{
    switch (aStep.getStepType)
    {
        case PLAY_ONCE:
            return UITableViewCellAccessoryDetailButton;
        case REPEAT:
            return UITableViewCellAccessoryDetailDisclosureButton;
        case INFINITE_LOOP:
            return UITableViewCellAccessoryDetailButton;
    }
}

- (AMSequenceStep*)getStepAssigned {
    return _sequenceStep;
}

- (IBAction)textFieldEditingChanged:(id)sender {
    [self adjustTextFieldsFrameWhileEditing];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_sequenceStep setName:_stepTitle.text];
    [self adjustTextFieldsFrame];
}

- (void)adjustTextFieldsFrame {
    CGFloat fixedWidth = _stepTitle.frame.size.width;
    CGSize newSize = [_stepTitle sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = _stepTitle.frame;
    newFrame.size = CGSizeMake(newSize.width, newSize.height);
    _stepTitle.frame = newFrame;
}

- (void)adjustTextFieldsFrameWhileEditing {
    CGFloat fixedWidth = _stepTitle.frame.size.width;
    CGSize newSize = [_stepTitle sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = _stepTitle.frame;
    newFrame.size = CGSizeMake(262.0f, newSize.height);
    newFrame.origin.x = 0.0f;
    _stepTitle.frame = newFrame;
}

@end
