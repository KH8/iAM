//
//  AMMenuTableViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 22.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequenceMenuTableViewCell.h"

@interface AMSequenceMenuTableViewCell ()

@property AMSequence *sequence;

@end

@implementation AMSequenceMenuTableViewCell

- (void)awakeFromNib {
    _titleLabel.delegate = self;
}

- (void)assignSequence:(AMSequence *)aSequence {
    _sequence = aSequence;
    _titleLabel.text = _sequence.getName;
    _detailLabel.text = [NSString stringWithFormat:@"CREATED: %@", _sequence.getCreationDateString];
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setSelectedWithColor:(UIColor *)color {
    _titleLabel.textColor = color;
}

- (IBAction)textFiledEditingChanged:(id)sender {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_sequence setName:_titleLabel.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
