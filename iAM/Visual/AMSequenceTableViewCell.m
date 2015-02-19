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
}

- (void)assignSequenceStep: (AMSequenceStep*)aStep{
    _sequenceStep = aStep;
    _stepTitle.text = _sequenceStep.getName;
    _stepSubtitle.text = _sequenceStep.getDescription;
}

- (AMSequenceStep*)getStepAssigned{
    return _sequenceStep;
}

- (IBAction)newLebelEnteringStarted:(id)sender {
    
}

- (IBAction)newLabelEntered:(id)sender {
    [_sequenceStep setName:_stepTitle.text];
    [self adjustTextFieldsFrame];
}

- (void)adjustTextFieldsFrame{
    CGFloat fixedWidth = _stepTitle.frame.size.width;
    CGSize newSize = [_stepTitle sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = _stepTitle.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    _stepTitle.frame = newFrame;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
