//
//  AMCollectionViewCell.m
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMCollectionViewCell.h"

@implementation AMCollectionViewCell

- (void)noteHasBeenTriggered {
    self.backgroundColor = [UIColor greenColor];
    [NSThread sleepForTimeInterval:1.0f];
    self.backgroundColor = [UIColor lightGrayColor];
}

@end
