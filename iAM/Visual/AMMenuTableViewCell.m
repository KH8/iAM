//
//  AMMenuTableViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 22.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMMenuTableViewCell.h"

@implementation AMMenuTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _titleLabel.textColor = [UIColor grayColor];
    if(self.isSelected){
        _titleLabel.textColor = [UIColor orangeColor];
    }
}

@end
