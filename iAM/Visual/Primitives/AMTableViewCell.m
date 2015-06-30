//
//  AMTableViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 10.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMTableViewCell.h"
#import "AMAppearanceManager.h"

@implementation AMTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated {
    [super setSelected:selected
              animated:animated];
    [self setSelectedWithColor:[UIColor grayColor]];
    if (self.isSelected) {
        [self setSelectedWithColor:[AMAppearanceManager getGlobalTintColor]];
    }
}

- (void)setSelectedWithColor:(UIColor *)color {

}

@end
