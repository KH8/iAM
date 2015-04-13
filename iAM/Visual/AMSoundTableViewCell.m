//
//  AMSequenceTableViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 16.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSoundTableViewCell.h"
#import "AMPlayer.h"

@interface AMSoundTableViewCell ()

@property NSString *key;
@property NSString *value;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;

@property AMPlayer *amPlayer;

@end

@implementation AMSoundTableViewCell

- (void)awakeFromNib {
}

- (void)setSelectionMarkerVisible {
    _selectionImageView.image = [[UIImage imageNamed:@"selectedLeft.png"]
                                 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _selectionImageView.contentMode = UIViewContentModeScaleAspectFit;
    _selectionImageView.tintColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _selectionImageView.tintColor = [UIColor blackColor];
    if(self.isSelected){
        [self setSelectionMarkerVisible];
        [self playSound];
    }
}

- (void) playSound {
    [_amPlayer setSoundName:_value withKey:_key];
    [_amPlayer playSound];
}

- (void)assignPlayer:(AMPlayer*)player{
    _amPlayer = player;
}

- (void)assignSoundKey: (NSString*)key{
    _key = key;
    _soundTitle.text = key;
}

- (void)assignSoundValue: (NSString*)value{
    _value = value;
}

- (NSString*)getValue{
    return _value;
}

@end
