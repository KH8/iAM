//
//  AMSequenceTableViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceTableViewCell.h"

@interface AMSequenceTableViewCell ()

@property AMSequenceStep *sequenceStep;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;

@end

@implementation AMSequenceTableViewCell

- (void)awakeFromNib {
    [self adjustTextFieldsFrame];
}

- (void)setSelectionMarkerVisible {
    _selectionImageView.image = [[UIImage imageNamed:@"selected.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _selectionImageView.contentMode = UIViewContentModeScaleAspectFit;
    _selectionImageView.tintColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [_stepTitle resignFirstResponder];
    
    _selectionImageView.tintColor = [UIColor blackColor];
    if(self.isSelected){
        [self setSelectionMarkerVisible];
    }
}

- (void)assignSequenceStep: (AMSequenceStep*)aStep {
    _sequenceStep = aStep;
    _stepTitle.text = _sequenceStep.getName;
    _stepSubtitle.text = _sequenceStep.getDescription;
    [self setAccessoryButton:_sequenceStep];
}

- (void)setAccessoryButton: (AMSequenceStep*)aStep {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 30, 30, 30)];
    switch (aStep.getStepType)
    {
        case PLAY_ONCE:
            [button setImage:[[UIImage imageNamed:@"seq1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                    forState:UIControlStateNormal];
            break;
        case REPEAT:
            [button setImage:[[UIImage imageNamed:@"seq2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                    forState:UIControlStateNormal];
            break;
        case INFINITE_LOOP:
            [button setImage:[[UIImage imageNamed:@"seq3.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                    forState:UIControlStateNormal];
            break;
    }
    [button addTarget:self action:@selector(changeStepType)
     forControlEvents:UIControlEventTouchUpInside];
    button.tintColor = [UIColor orangeColor];
    self.accessoryType = UITableViewCellAccessoryDetailButton;
    self.accessoryView = button;
}

- (void)changeStepType {
    [_sequenceStep setNextStepType];
    [self setAccessoryButton:_sequenceStep];
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
    CGSize newSize = [_stepTitle sizeThatFits:CGSizeMake(fixedWidth, 160.0)];
    CGRect newFrame = CGRectMake(newSize.width, newSize.height, 160.0, newSize.height);
    _stepTitle.frame = newFrame;
}

- (void)adjustTextFieldsFrameWhileEditing {
    CGRect newFrame = _stepTitle.frame;
    newFrame.size = CGSizeMake(284.0, _stepTitle.frame.size.height);
    newFrame.origin.x = 0.0;
    _stepTitle.frame = newFrame;
}

@end
