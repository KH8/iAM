//
//  AMSequenceTableViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSoundTableViewCell.h"

@interface AMSoundTableViewCell ()

@property NSString *key;
@property NSString *value;

@property AMPlayer *amPlayer;

@end

@implementation AMSoundTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setSelectedWithColor:(UIColor *)color {
    _soundTitle.textColor = color;
    if (self.isSelected) {
        [self playSound];
    }
}

- (void)playSound {
    [_amPlayer setSoundName:_value withKey:_key];
    [_amPlayer playSound];
}

- (void)assignPlayer:(AMPlayer *)player {
    _amPlayer = player;
}

- (void)assignSoundKey:(NSString *)key {
    _key = key;
    _soundTitle.text = key;
}

- (void)assignSoundValue:(NSString *)value {
    _value = value;
}

- (NSString *)getValue {
    return _value;
}

@end
