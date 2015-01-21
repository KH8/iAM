//
//  AMCollectionViewCell.h
//  iAM
//
//  Created by Krzysztof Reczek on 06.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMNote.h"

@interface AMCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) AMNote *noteAssigned;

@end
